#!/bin/bash
# test-unit.sh - Run unit tests for the project

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

echo -e "${BLUE}[INFO]${NC} Running unit tests..."

# Check for common test runners and run the appropriate one
if [ -f "package.json" ]; then
    if grep -q '"test"' package.json; then
        echo -e "${BLUE}[INFO]${NC} Found npm/yarn project, running tests..."
        if [ -f "yarn.lock" ]; then
            yarn test
        elif [ -f "pnpm-lock.yaml" ]; then
            pnpm test
        else
            npm test
        fi
    else
        echo -e "${YELLOW}[WARNING]${NC} No test script found in package.json"
    fi
elif [ -f "Cargo.toml" ]; then
    echo -e "${BLUE}[INFO]${NC} Found Rust project, running tests..."
    cargo test
elif [ -f "go.mod" ]; then
    echo -e "${BLUE}[INFO]${NC} Found Go project, running tests..."
    go test ./...
elif [ -f "requirements.txt" ] || [ -f "pyproject.toml" ]; then
    echo -e "${BLUE}[INFO]${NC} Found Python project, running tests..."
    if command -v pytest >/dev/null 2>&1; then
        pytest
    elif command -v python -m pytest >/dev/null 2>&1; then
        python -m pytest
    else
        echo -e "${YELLOW}[WARNING]${NC} No pytest found, trying unittest..."
        python -m unittest discover
    fi
else
    echo -e "${YELLOW}[WARNING]${NC} No recognized project type found"
    echo -e "${YELLOW}[WARNING]${NC} Add your test command to test-unit.sh"
    exit 0
fi

echo -e "${GREEN}[SUCCESS]${NC} Unit tests completed"