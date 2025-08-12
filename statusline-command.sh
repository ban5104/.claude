#!/bin/bash

# Claude Code Status Line - Simple Directory/Git/Model Display
# Must output ONLY to stdout, no stderr
# First line of stdout becomes the status line
#
# Features:
# - Directory display (green)
# - Git branch and status (red for dirty, cyan for clean)
# - Model name detection (Opus 4.1 when settings.json has "model": "opus")
#
# Usage:
# Normal: ~/.claude/statusline-command.sh (called by Claude Code)

# Remove old cache directory and files from previous token tracking system
if [ -d "$HOME/.claude/statusline-cache" ]; then
    rm -rf "$HOME/.claude/statusline-cache" 2>/dev/null
fi

# Read JSON input from stdin (Claude Code sends this automatically)
input=$(timeout 0.1 cat 2>/dev/null || echo '{}')

# Parse JSON - try jq first, then fallback
model_name="Sonnet 4"  # Default value
current_dir=$(pwd)     # Default to current directory
project_dir=""

if command -v jq >/dev/null 2>&1 && [ -n "$input" ] && [ "$input" != "{}" ]; then
    # Use jq if available and input is valid
    model_name=$(echo "$input" | jq -r '.model.display_name // "Sonnet 4"' 2>/dev/null || echo "Sonnet 4")
    current_dir=$(echo "$input" | jq -r '.workspace.current_dir // .cwd // ""' 2>/dev/null || pwd)
    project_dir=$(echo "$input" | jq -r '.workspace.project_dir // ""' 2>/dev/null || echo "")
else
    # Fallback: Check settings.json for model when Claude Code sends empty JSON
    settings_file="$HOME/.claude/settings.json"
    if [ -f "$settings_file" ] && command -v jq >/dev/null 2>&1; then
        settings_model=$(jq -r '.model // ""' "$settings_file" 2>/dev/null || echo "")
        
        if [ "$settings_model" = "opus" ]; then
            model_name="Opus 4.1"
        elif [ -n "$settings_model" ]; then
            # Handle other model names from settings
            case "$settings_model" in
                "sonnet")
                    model_name="Sonnet 4"
                    ;;
                "haiku")
                    model_name="Haiku 4"
                    ;;
                *)
                    model_name="$settings_model"
                    ;;
            esac
        fi
    fi
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
RESET='\033[0m'

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

# Build status line parts
dir_display_safe="${dir_display:-social-manager-app}"
model_name_safe="${model_name:-Sonnet 4}"

# Start building the status line
printf "%b%s%b" "${GREEN}" "${dir_display_safe}" "${RESET}"

# Add git info
get_git_info "$current_dir"

# Add model name
printf " %b%s%b" "${PURPLE}" "${model_name_safe}" "${RESET}"

# End with newline
printf "\n"