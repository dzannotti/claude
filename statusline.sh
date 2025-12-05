#!/bin/bash

# Powerline symbols - replace these as needed
LEFT_CAP=""      # U+E0B6 rounded left
ARROW=""         # U+E0B0 arrow divider
RIGHT_CAP=""     # U+E0B4 rounded right

# Catppuccin Mocha colors (RGB)
PEACH_BG="48;2;250;179;135"
GREEN_BG="48;2;166;227;161"
TEAL_BG="48;2;148;226;213"
PEACH_FG="38;2;250;179;135"
GREEN_FG="38;2;166;227;161"
TEAL_FG="38;2;148;226;213"
BASE_FG="38;2;30;30;46"
MANTLE_FG="38;2;24;24;37"

input=$(cat)
d=$(echo "$input" | jq -r '.workspace.current_dir')
cd "$d" 2>/dev/null

# Truncate path
p=$(echo "$d" | awk -F/ '{n=NF;if(n<=3)print $0;else printf"…/%s/%s/%s",$(n-2),$(n-1),$n}')

# Path segment (peach)
printf "\033[${PEACH_FG}m${LEFT_CAP}\033[${PEACH_BG};${MANTLE_FG}m %s \033[0m" "$p"

if git rev-parse --git-dir >/dev/null 2>&1; then
    b=$(git branch --show-current 2>/dev/null)

    # Arrow: peach -> green
    printf "\033[${GREEN_BG};${PEACH_FG}m${ARROW}\033[0m"

    # Branch segment (green)
    printf "\033[${GREEN_BG};${BASE_FG}m  %s \033[0m" "$b"

    # Check for uncommitted changes
    diff=$(git diff --numstat 2>/dev/null | awk '{a+=$1;r+=$2}END{if(a||r)printf "+%d -%d",a,r}')

    if [ -n "$diff" ]; then
        # Arrow: green -> teal
        printf "\033[${TEAL_BG};${GREEN_FG}m${ARROW}\033[0m"
        # Diff segment (teal)
        printf "\033[${TEAL_BG};${BASE_FG}m %s \033[0m" "$diff"
        # End cap (teal)
        printf "\033[49;${TEAL_FG}m${RIGHT_CAP}\033[0m"
    else
        # End cap (green)
        printf "\033[49;${GREEN_FG}m${RIGHT_CAP}\033[0m"
    fi
else
    # End cap (peach, no git)
    printf "\033[49;${PEACH_FG}m${RIGHT_CAP}\033[0m"
fi
