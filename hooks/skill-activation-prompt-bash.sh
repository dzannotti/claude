#!/bin/bash

# Smart Skill Activation Hook - Bash Version
# Analyzes user prompts and suggests relevant skills based on keywords and patterns

# Read JSON input from stdin
input_json=$(cat 2>/dev/null || echo '{}')

# Parse prompt from input
prompt=$(echo "$input_json" | jq -r '.prompt // ""' 2>/dev/null | tr '[:upper:]' '[:lower:]')

# Exit early if no prompt
if [[ -z "$prompt" ]]; then
    exit 0
fi

# Find the correct skills directory
skills_dir=""
if [[ -n "$CLAUDE_PROJECT_DIR" && -f "$CLAUDE_PROJECT_DIR/.claude/skills/skill-rules.json" ]]; then
    skills_dir="$CLAUDE_PROJECT_DIR/.claude/skills"
elif [[ -f "$HOME/.claude/skills/skill-rules.json" ]]; then
    skills_dir="$HOME/.claude/skills"
elif [[ -f "$(pwd)/.claude/skills/skill-rules.json" ]]; then
    skills_dir="$(pwd)/.claude/skills"
fi

rules_file="$skills_dir/skill-rules.json"

# Exit if rules file doesn't exist
if [[ ! -f "$rules_file" ]]; then
    exit 0
fi

# Parse rules and check matches
matched_skills=""
priorities=""

# Extract skill names from rules file
skill_names=$(jq -r '.skills | keys[]' "$rules_file" 2>/dev/null)

for skill in $skill_names; do
    # Extract keywords and patterns for this skill
    keywords=$(jq -r ".skills.\"$skill\".promptTriggers.keywords[]? // empty" "$rules_file" 2>/dev/null | tr '[:upper:]' '[:lower:]')
    patterns=$(jq -r ".skills.\"$skill\".promptTriggers.intentPatterns[]? // empty" "$rules_file" 2>/dev/null)
    priority=$(jq -r ".skills.\"$skill\".priority // \"medium\"" "$rules_file" 2>/dev/null)

    # Check keyword matches
    keyword_match=false
    while IFS= read -r keyword; do
        if [[ -n "$keyword" && "$prompt" == *"$keyword"* ]]; then
            keyword_match=true
            break
        fi
    done <<< "$keywords"

    # Check pattern matches if no keyword match
    pattern_match=false
    if [[ "$keyword_match" != "true" ]]; then
        while IFS= read -r pattern; do
            if [[ -n "$pattern" ]] && echo "$prompt" | grep -qiE "$pattern"; then
                pattern_match=true
                break
            fi
        done <<< "$patterns"
    fi

    # Add to matched skills if either type matched
    if [[ "$keyword_match" == "true" || "$pattern_match" == "true" ]]; then
        matched_skills="$matched_skills$skill "
        priorities="$priorities$skill:$priority "
    fi
done

# Generate output if matches found
if [[ -n "$matched_skills" ]]; then
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo "🎯 SKILL ACTIVATION CHECK"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
    echo ""

    # Group by priority
    critical_skills=""
    high_skills=""
    medium_skills=""
    low_skills=""

    for priority_item in $priorities; do
        skill_name=${priority_item%%:*}
        priority_level=${priority_item##*:}

        case "$priority_level" in
            "critical") critical_skills="$critical_skills$skill_name " ;;
            "high") high_skills="$high_skills$skill_name " ;;
            "medium") medium_skills="$medium_skills$skill_name " ;;
            "low") low_skills="$low_skills$skill_name " ;;
        esac
    done

    # Output by priority groups
    if [[ -n "$critical_skills" ]]; then
        echo "⚠️ CRITICAL SKILLS (REQUIRED):"
        for skill in $critical_skills; do
            echo "  → $skill"
        done
        echo ""
    fi

    if [[ -n "$high_skills" ]]; then
        echo "📚 RECOMMENDED SKILLS:"
        for skill in $high_skills; do
            echo "  → $skill"
        done
        echo ""
    fi

    if [[ -n "$medium_skills" ]]; then
        echo "💡 SUGGESTED SKILLS:"
        for skill in $medium_skills; do
            echo "  → $skill"
        done
        echo ""
    fi

    if [[ -n "$low_skills" ]]; then
        echo "📌 OPTIONAL SKILLS:"
        for skill in $low_skills; do
            echo "  → $skill"
        done
        echo ""
    fi

    echo "ACTION: Use Skill tool BEFORE responding"
    echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
fi

exit 0
