#!/bin/bash

# Read JSON input
input=$(cat)

# Get current directory from JSON
cwd=$(echo "$input" | jq -r '.workspace.current_dir')

# Extract folder name
folder=$(basename "$cwd")

# Get hostname
hostname=$(hostname -s)

# Colors (matching starship theme)
DIM='\033[2m'
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
CYAN='\033[1;36m'
PURPLE='\033[0;35m'
RESET='\033[0m'

# Initialize output (starship-style)
output=$(printf "${DIM}${hostname}${RESET}")
output+=$(printf " ${GREEN}❯${RESET}")
output+=$(printf " ${BLUE}${folder}${RESET}")

# Check if in a git repository
if [ -d "${cwd}/.git" ] || git -C "$cwd" rev-parse --git-dir > /dev/null 2>&1; then
    # Get current branch
    branch=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref HEAD 2>/dev/null)

    if [ -n "$branch" ]; then
        output+=$(printf " ${PURPLE} ${branch}${RESET}")

        # Get file counts using git status --porcelain
        status=$(git -C "$cwd" --no-optional-locks status --porcelain 2>/dev/null)

        if [ -n "$status" ]; then
            # Count different types
            staged=$(echo "$status" | grep -c '^[MADRC]')
            modified=$(echo "$status" | grep -c '^.M')
            untracked=$(echo "$status" | grep -c '^??')

            # Build status string
            stats=""
            [ "$staged" -gt 0 ] && stats+=$(printf "${GREEN}+${staged}${RESET}")
            [ "$modified" -gt 0 ] && stats+=$(printf "${YELLOW}~${modified}${RESET}")
            [ "$untracked" -gt 0 ] && stats+=$(printf "${RED}?${untracked}${RESET}")

            [ -n "$stats" ] && output+=" ${stats}"
        fi

        # Check ahead/behind (if tracking remote)
        upstream=$(git -C "$cwd" --no-optional-locks rev-parse --abbrev-ref @{upstream} 2>/dev/null)
        if [ -n "$upstream" ]; then
            ahead=$(git -C "$cwd" --no-optional-locks rev-list --count @{upstream}..HEAD 2>/dev/null)
            behind=$(git -C "$cwd" --no-optional-locks rev-list --count HEAD..@{upstream} 2>/dev/null)

            sync=""
            [ "$ahead" -gt 0 ] && sync+="↑${ahead}"
            [ "$behind" -gt 0 ] && sync+="↓${behind}"

            [ -n "$sync" ] && output+=$(printf " ${CYAN}${sync}${RESET}")
        fi
    fi
fi

echo "$output"
