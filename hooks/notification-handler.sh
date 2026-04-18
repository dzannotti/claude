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

# Escape for PowerShell single-quoted string (double-up embedded quotes)
ps_escape() { printf '%s' "$1" | sed "s/'/''/g"; }

notify_wsl() {
    command -v powershell.exe &>/dev/null || return 1
    local t m
    t=$(ps_escape "$title")
    m=$(ps_escape "$message")
    powershell.exe -NoProfile -WindowStyle Hidden -Command \
        "Add-Type -AssemblyName System.Windows.Forms; \
         Add-Type -AssemblyName System.Drawing; \
         \$n = New-Object System.Windows.Forms.NotifyIcon; \
         \$n.Icon = [System.Drawing.SystemIcons]::Information; \
         \$n.Visible = \$true; \
         \$n.ShowBalloonTip(5000, '$t', '$m', 'Info'); \
         Start-Sleep -Seconds 5; \
         \$n.Dispose()" \
        >/dev/null 2>&1 &
}

# Send notification (cross-platform)
case "$(uname -s)" in
    Darwin)
        terminal-notifier -title "$title" -message "$message" 2>/dev/null || \
        osascript -e "display notification \"$message\" with title \"$title\"" 2>/dev/null
        afplay /System/Library/Sounds/Glass.aiff &
        ;;
    Linux)
        if grep -qi microsoft /proc/version 2>/dev/null; then
            # WSL: no D-Bus, use PowerShell toast + terminal bell
            notify_wsl || printf '\a' >&2
        else
            notify-send "$title" "$message" 2>/dev/null
            if command -v paplay &>/dev/null; then
                paplay /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
            elif command -v pw-play &>/dev/null; then
                pw-play /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
            elif command -v mpv &>/dev/null; then
                mpv --no-video --really-quiet /usr/share/sounds/freedesktop/stereo/message.oga 2>/dev/null &
            fi
        fi
        ;;
esac
