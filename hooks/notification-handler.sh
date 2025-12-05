#!/usr/bin/env bash
# Cross-platform Claude Code notification handler
# Parses hook input to show contextual notifications

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Read stdin
input=$(cat)

# Parse transcript path from hook input
transcript_path=$(echo "$input" | jq -r '.transcript_path // ""')

if [ -n "$transcript_path" ] && [ -f "$transcript_path" ]; then
    last_line=$(tail -1 "$transcript_path")

    tool_name=$(echo "$last_line" | jq -r '.message.content[0].name // ""' 2>/dev/null)
    command=$(echo "$last_line" | jq -r '.message.content[0].input.command // ""' 2>/dev/null)
    description=$(echo "$last_line" | jq -r '.message.content[0].input.description // ""' 2>/dev/null)
    file_path=$(echo "$last_line" | jq -r '.message.content[0].input.file_path // ""' 2>/dev/null)

    if [ -n "$command" ] && [ -n "$description" ]; then
        title="CC: $command"
        message="$description"
    elif [ -n "$tool_name" ] && [ -n "$file_path" ]; then
        file_name=$(basename "$file_path")
        title="CC: $tool_name"
        message="File: $file_name"
    elif [ -n "$tool_name" ]; then
        title="CC: $tool_name"
        message="Claude needs your permission to use $tool_name"
    else
        title="CC: Claude Code"
        message="Claude needs your permission"
    fi
else
    title="CC: Claude Code"
    message="Claude needs your permission"
fi

# Send notification (cross-platform)
case "$(uname -s)" in
    Darwin)
        terminal-notifier -title "$title" -message "$message" 2>/dev/null || \
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null
        afplay /System/Library/Sounds/Glass.aiff &
        ;;
    Linux)
        notify-send "$title" "$message" 2>/dev/null
        if command -v paplay &>/dev/null; then
            paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
        elif command -v pw-play &>/dev/null; then
            pw-play /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
        elif command -v mpv &>/dev/null; then
            mpv --no-video --really-quiet /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
        fi
        ;;
esac
