#!/bin/bash

# Directory Context Injector - UserPromptSubmit
# SAFE VERSION: Always succeeds, never blocks
# Shows actual shell working directory vs Claude's expectations

# Read input with error suppression (safe even if stdin is empty)
input_json=$(cat 2>/dev/null || echo '{}')

# Get ACTUAL shell working directory (ground truth)
actual_dir=$(pwd 2>/dev/null || echo "")

# Parse what Claude thinks the directory should be
claude_cwd=$(echo "$input_json" | jq -r '.cwd // ""' 2>/dev/null || echo "")

# Always show the actual shell directory first (where commands will execute)
if [ -n "$actual_dir" ] && [ -d "$actual_dir" ]; then
    echo "📍 Shell working directory: $actual_dir"

    # Check for mismatch between Claude's expectation and shell reality
    if [ -n "$claude_cwd" ] && [ "$claude_cwd" != "$actual_dir" ]; then
        echo "⚠️  Claude expects: $claude_cwd"
        echo "   🔍 DIRECTORY MISMATCH DETECTED!"
        echo "   "
        echo "   This means:"
        echo "   • Your bash commands will run in: $actual_dir"
        echo "   • Claude thinks you're working in: $claude_cwd"
        echo "   "
        echo "   To validate your location:"
        echo "   • Check if you're in the right project directory"
        echo "   • Verify the directory matches your current task"
        echo "   "
    fi
fi

# CRITICAL: Always exit 0 (success) - never block the prompt!
exit 0
