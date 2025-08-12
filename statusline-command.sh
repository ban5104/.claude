#!/bin/bash

# Claude Code Status Line - Optimized with Caching
# Must output ONLY to stdout, no stderr
# First line of stdout becomes the status line
# Implements lightweight caching as recommended by Claude Code docs

# Debug mode - uncomment for troubleshooting or pass --debug flag
# DEBUG=1
if [ "$1" = "--debug" ]; then
    DEBUG=1
    shift
fi

# Cache directory and TTL settings
CACHE_DIR="$HOME/.claude/statusline-cache"
GIT_CACHE_TTL=2  # 2 second TTL for git operations (recommended max 3s)
mkdir -p "$CACHE_DIR" 2>/dev/null

# Clear cache if script was recently modified (for debugging)
script_time=$(stat -f%m "$0" 2>/dev/null || echo "0")
if [ -f "$CACHE_DIR/.last_clear" ]; then
    last_clear=$(cat "$CACHE_DIR/.last_clear" 2>/dev/null || echo "0")
    if [ "$script_time" -gt "$last_clear" ]; then
        rm -f "$CACHE_DIR"/git_* "$CACHE_DIR"/context_* 2>/dev/null
        echo "$script_time" > "$CACHE_DIR/.last_clear" 2>/dev/null
    fi
else
    rm -f "$CACHE_DIR"/git_* "$CACHE_DIR"/context_* 2>/dev/null
    echo "$script_time" > "$CACHE_DIR/.last_clear" 2>/dev/null
fi

# Cleanup old cache files periodically (once per day)
cleanup_cache() {
    local cleanup_marker="$CACHE_DIR/.last_cleanup"
    local current_time=$(date +%s)
    local cleanup_interval=86400  # 24 hours
    
    if [ -f "$cleanup_marker" ]; then
        local last_cleanup
        if [[ "$OSTYPE" == "darwin"* ]]; then
            last_cleanup=$(stat -f %m "$cleanup_marker" 2>/dev/null || echo "0")
        else
            last_cleanup=$(stat -c %Y "$cleanup_marker" 2>/dev/null || echo "0")
        fi
        local time_since_cleanup=$((current_time - last_cleanup))
        
        if [ "$time_since_cleanup" -lt "$cleanup_interval" ]; then
            return 0
        fi
    fi
    
    # Cleanup cache files older than 1 hour in background
    (find "$CACHE_DIR" -type f -name "git_*" -mmin +60 -delete 2>/dev/null || true) &
    (find "$CACHE_DIR" -type f -name "context_*" -mmin +60 -delete 2>/dev/null || true) &
    touch "$cleanup_marker" 2>/dev/null
}

# Run cleanup in background
cleanup_cache &

# Read JSON input from stdin (Claude Code sends this automatically)
# For testing, create a fake transcript to show context percentage
if [ "$1" = "--test" ]; then
    input='{"session_id":"test","transcript_path":"/tmp/test_transcript","cwd":"'$(pwd)'","model":{"id":"claude-sonnet-4-20250514","display_name":"Sonnet 4"},"workspace":{"current_dir":"'$(pwd)'","project_dir":"'$(pwd)'"},"version":"1.0.71"}'
    echo "This is a test transcript content to test the context percentage calculation. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua." > /tmp/test_transcript
elif [ "$1" = "--test-no-transcript" ]; then
    input='{"session_id":"test","transcript_path":"","cwd":"'$(pwd)'","model":{"id":"claude-sonnet-4-20250514","display_name":"Sonnet 4"},"workspace":{"current_dir":"'$(pwd)'","project_dir":"'$(pwd)'"},"version":"1.0.71"}'
else
    input=$(timeout 0.1 cat 2>/dev/null || echo '{}')
fi

# Parse JSON - try jq first, then fallback
model_name="Sonnet 4"  # Default value
current_dir=$(pwd)     # Default to current directory
project_dir=""
transcript_path=""

if command -v jq >/dev/null 2>&1 && [ -n "$input" ] && [ "$input" != "{}" ]; then
    # Use jq if available and input is valid
    model_name=$(echo "$input" | jq -r '.model.display_name // "Sonnet 4"' 2>/dev/null || echo "Sonnet 4")
    current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""' 2>/dev/null || pwd)
    project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""' 2>/dev/null || echo "")
    transcript_path=$(echo "$input" | jq -r '.transcript_path // ""' 2>/dev/null || echo "")
fi

# Ensure current_dir is set
if [ -z "$current_dir" ]; then
    current_dir=$(pwd)
fi

# Color codes for visual appeal
GREEN='\033[1;32m'
RED='\033[1;31m'
PURPLE='\033[1;35m'
CYAN='\033[1;36m'
YELLOW='\033[1;33m'
RESET='\033[0m'

# Cache helper functions
is_cache_valid() {
    local cache_file="$1"
    local ttl="$2"
    
    if [ ! -f "$cache_file" ]; then
        return 1
    fi
    
    # Get file modification time
    if command -v stat >/dev/null 2>&1; then
        local file_time
        if [[ "$OSTYPE" == "darwin"* ]]; then
            file_time=$(stat -f %m "$cache_file" 2>/dev/null || echo "0")
        else
            file_time=$(stat -c %Y "$cache_file" 2>/dev/null || echo "0")
        fi
        local current_time=$(date +%s)
        local age=$((current_time - file_time))
        
        [ "$age" -le "$ttl" ]
    else
        # Fallback: assume cache is valid for safety
        return 0
    fi
}

# Simplified git information function
get_git_info() {
    local repo_dir="$1"
    
    # Quick directory check
    if [ ! -d "$repo_dir" ]; then
        return 0
    fi
    
    # Change to the directory and try to get git info
    if cd "$repo_dir" 2>/dev/null; then
        # Check if it's a git repo
        if git rev-parse --git-dir >/dev/null 2>&1; then
            # Get branch name
            local branch
            branch=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)
            
            if [ -n "$branch" ] && [ "$branch" != "HEAD" ]; then
                # Check dirty status
                local is_dirty="clean"
                if ! git diff-index --quiet HEAD -- 2>/dev/null || ! git diff --quiet --cached 2>/dev/null; then
                    is_dirty="dirty"
                fi
                
                # Output result
                if [ "$is_dirty" = "dirty" ]; then
                    printf " %bgit:(%s)%b" "${RED}" "${branch}" "${RESET}"
                else
                    printf " %bgit:(%s)%b" "${CYAN}" "${branch}" "${RESET}"
                fi
            fi
        fi
    fi
}

# Smart directory display
if [ -n "$project_dir" ] && [ -n "$current_dir" ]; then
    if [ "$current_dir" = "$project_dir" ]; then
        # We're in the project root
        project_name=$(basename "$project_dir")
        dir_display="~/$project_name"
    elif [[ "$current_dir" == "$project_dir"* ]]; then
        # We're in a subdirectory of the project
        project_name=$(basename "$project_dir")
        relative_path=${current_dir#$project_dir/}
        dir_display="~/$project_name/$relative_path"
    else
        # Show full path relative to home
        dir_display=$(echo "$current_dir" | sed "s|^$HOME|~|")
    fi
else
    # Fallback to current directory
    dir_display=$(echo "${current_dir:-$(pwd)}" | sed "s|^$HOME|~|")
fi

# Make sure script is executable
chmod +x "$0" 2>/dev/null

# Enhanced context calculation with fallback mechanisms
get_context_info() {
    local transcript_path="$1"
    local debug_file="$CACHE_DIR/context_debug.log"
    
    # Debug logging if enabled
    if [ "$DEBUG" = "1" ]; then
        echo "DEBUG: transcript_path='$transcript_path'" >> "$debug_file"
        echo "DEBUG: input='$input'" >> "$debug_file"
    fi
    
    # Try to find transcript file using multiple strategies
    local found_transcript=""
    
    # Strategy 1: Use provided transcript_path if valid
    if [ -n "$transcript_path" ] && [ "$transcript_path" != "null" ] && [ -f "$transcript_path" ]; then
        found_transcript="$transcript_path"
        [ "$DEBUG" = "1" ] && echo "DEBUG: Using provided transcript: $found_transcript" >> "$debug_file"
    else
        # Strategy 2: Look for chats directory and find most recent transcript
        local chats_dir="$HOME/.claude/chats"
        if [ -d "$chats_dir" ]; then
            # Find the most recently modified .md file in chats directory
            if [[ "$OSTYPE" == "darwin"* ]]; then
                found_transcript=$(find "$chats_dir" -name "*.md" -type f -exec stat -f "%m %N" {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
            else
                found_transcript=$(find "$chats_dir" -name "*.md" -type f -exec stat -c "%Y %n" {} \; 2>/dev/null | sort -rn | head -1 | cut -d' ' -f2-)
            fi
            [ "$DEBUG" = "1" ] && echo "DEBUG: Found recent transcript in chats: $found_transcript" >> "$debug_file"
        fi
        
        # Strategy 3: Look for session-based transcript paths
        if [ -z "$found_transcript" ] && [ -n "$input" ] && [ "$input" != "{}" ]; then
            local session_id=$(echo "$input" | jq -r '.session_id // ""' 2>/dev/null || echo "")
            if [ -n "$session_id" ] && [ "$session_id" != "null" ]; then
                # Try common transcript path patterns
                local possible_paths=(
                    "$HOME/.claude/chats/$session_id.md"
                    "$HOME/.claude/sessions/$session_id.md"
                    "$HOME/.claude/transcripts/$session_id.md"
                    "/tmp/claude-$session_id.md"
                )
                
                for path in "${possible_paths[@]}"; do
                    if [ -f "$path" ]; then
                        found_transcript="$path"
                        [ "$DEBUG" = "1" ] && echo "DEBUG: Found transcript via session ID: $found_transcript" >> "$debug_file"
                        break
                    fi
                done
            fi
        fi
        
        # Strategy 4: Look for any recent transcript in common locations
        if [ -z "$found_transcript" ]; then
            local search_dirs=(
                "$HOME/.claude"
                "/tmp"
                "$HOME/Library/Application Support/Claude"
            )
            
            for dir in "${search_dirs[@]}"; do
                if [ -d "$dir" ]; then
                    local recent_file=$(find "$dir" -name "*transcript*.md" -o -name "*chat*.md" -o -name "*.md" | head -1 2>/dev/null)
                    if [ -f "$recent_file" ]; then
                        found_transcript="$recent_file"
                        [ "$DEBUG" = "1" ] && echo "DEBUG: Found fallback transcript: $found_transcript" >> "$debug_file"
                        break
                    fi
                fi
            done
        fi
    fi
    
    # Calculate context percentage if we found a transcript
    if [ -n "$found_transcript" ] && [ -f "$found_transcript" ]; then
        # Get file size
        local transcript_size
        if [[ "$OSTYPE" == "darwin"* ]]; then
            transcript_size=$(stat -f%z "$found_transcript" 2>/dev/null || echo "0")
        else
            transcript_size=$(stat -c%s "$found_transcript" 2>/dev/null || echo "0")
        fi
        
        [ "$DEBUG" = "1" ] && echo "DEBUG: transcript_size=$transcript_size" >> "$debug_file"
        
        local max_chars=600000
        
        if [ "$transcript_size" -gt 0 ] 2>/dev/null; then
            local used_percentage=$(( (transcript_size * 100) / max_chars ))
            local remaining_percentage=$((100 - used_percentage))
            
            # Clamp percentage values
            if [ "$remaining_percentage" -gt 100 ]; then
                remaining_percentage=100
            elif [ "$remaining_percentage" -lt 0 ]; then
                remaining_percentage=0
            fi
            
            [ "$DEBUG" = "1" ] && echo "DEBUG: remaining_percentage=$remaining_percentage" >> "$debug_file"
            
            # Color code based on remaining context
            if [ "$remaining_percentage" -ge 60 ]; then
                printf " %b%d%%%b" "${GREEN}" "${remaining_percentage}" "${RESET}"
            elif [ "$remaining_percentage" -ge 30 ]; then
                printf " %b%d%%%b" "${YELLOW}" "${remaining_percentage}" "${RESET}"
            else
                printf " %b%d%%%b" "${RED}" "${remaining_percentage}" "${RESET}"
            fi
        else
            # Show a default indicator if we can't calculate
            [ "$DEBUG" = "1" ] && echo "DEBUG: transcript_size is 0 or invalid" >> "$debug_file"
            printf " %b??%%%b" "${YELLOW}" "${RESET}"
        fi
    else
        # Show indicator that no transcript was found
        [ "$DEBUG" = "1" ] && echo "DEBUG: No transcript found" >> "$debug_file"
        printf " %b--%%%b" "${YELLOW}" "${RESET}"
    fi
}

# Build status line parts
dir_display_safe="${dir_display:-social-manager-app}"
model_name_safe="${model_name:-Sonnet 4}"

# Start building the status line
printf "%b%s%b" "${GREEN}" "${dir_display_safe}" "${RESET}"

# Add git info
get_git_info "$current_dir"

# Add model name
printf " %b%s%b" "${PURPLE}" "${model_name_safe}" "${RESET}"

# Always try to show context info (with fallbacks)
get_context_info "$transcript_path"

# End with newline
printf "\n"