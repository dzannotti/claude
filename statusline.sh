#!/bin/bash
# Single-line statusline: model | context fuel gauge | branch | uncommitted diff | Δmain
set -u
input=$(cat)

command -v jq >/dev/null 2>&1 || { printf 'statusline: jq required\n'; exit 0; }

use_color=1
[ -n "${NO_COLOR:-}" ] && use_color=0
C()   { [ "$use_color" -eq 1 ] && printf '\033[%sm' "$1"; }
RST() { [ "$use_color" -eq 1 ] && printf '\033[0m'; }

model_c='38;5;147'    # light purple
branch_c='38;5;150'   # soft green
div_c='38;5;240'      # dim gray
add_c='38;5;114'      # green
del_c='38;5;203'      # coral red
label_c='38;5;245'    # gray

model_name=$(printf '%s' "$input" | jq -r '.model.display_name // "Claude"')
ctx_size=$(printf '%s'   "$input" | jq -r '.context_window.context_window_size // 200000')
cur_tokens=$(printf '%s' "$input" | jq -r '
  (.context_window.current_usage // {}) as $u
  | ($u.input_tokens // 0) + ($u.cache_creation_input_tokens // 0) + ($u.cache_read_input_tokens // 0)')
[[ "$cur_tokens" =~ ^[0-9]+$ ]] || cur_tokens=0
[[ "$ctx_size"   =~ ^[0-9]+$ ]] || ctx_size=200000

# Strip trailing "(... context)" from model name, add compact tag
model_short=$(printf '%s' "$model_name" | sed -E 's/[[:space:]]*\([^)]*\)[[:space:]]*$//')
if   [ "$ctx_size" -ge 1000000 ]; then ctx_tag="[1M]"
elif [ "$ctx_size" -ge 500000 ];  then ctx_tag="[$((ctx_size/1000))k]"
else                                    ctx_tag="[$((ctx_size/1000))k]"
fi

fmt_k() {
  local n=$1
  if   [ "$n" -ge 1000000 ]; then awk -v n="$n" 'BEGIN{printf "%.1fM", n/1000000}'
  elif [ "$n" -ge 1000 ];    then printf '%dk' $((n/1000))
  else                            printf '%d' "$n"
  fi
}
cur_k=$(fmt_k "$cur_tokens")
max_k=$(fmt_k "$ctx_size")

pct_used=0
[ "$ctx_size" -gt 0 ] && pct_used=$(( cur_tokens * 100 / ctx_size ))
(( pct_used > 100 )) && pct_used=100

bar_w=10
# Fuel gauge: filled = REMAINING (not used). 20% used -> 8 filled, 2 empty on right.
# Half-up rounding so 81% remaining -> 8 blocks, 86% -> 9 blocks.
pct_remaining=$(( 100 - pct_used ))
filled=$(( (pct_remaining * bar_w + 50) / 100 ))
(( filled > bar_w )) && filled=$bar_w
(( filled < 0 ))     && filled=0
filled_blocks=""
empty_blocks=""
for ((i=0; i<filled;       i++)); do filled_blocks+="█"; done
for ((i=0; i<bar_w-filled; i++)); do empty_blocks+="░"; done

# Truecolor gradient: green(0,220,120) -> yellow(230,200,0) -> red(230,70,70)
if [ "$pct_used" -lt 50 ]; then
  t=$pct_used  # 0..49
  r=$(( 0   + (230 - 0)   * t / 50 ))
  g=$(( 220 + (200 - 220) * t / 50 ))
  b=$(( 120 + (0   - 120) * t / 50 ))
else
  t=$(( pct_used - 50 ))  # 0..50
  r=$(( 230 + (230 - 230) * t / 50 ))
  g=$(( 200 + (70  - 200) * t / 50 ))
  b=$(( 0   + (70  - 0)   * t / 50 ))
fi
gauge_c="38;2;${r};${g};${b}"
empty_c='38;5;238'  # dim gray for unfilled blocks

git_branch="" uc_add=0 uc_del=0 dm_add=0 dm_del=0 main_name=""
if git rev-parse --git-dir >/dev/null 2>&1; then
  git_branch=$(git branch --show-current 2>/dev/null)
  [ -z "$git_branch" ] && git_branch=$(git rev-parse --short HEAD 2>/dev/null)

  uc_stat=$(git diff HEAD --shortstat 2>/dev/null)
  uc_add=$(printf '%s' "$uc_stat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' | head -1)
  uc_del=$(printf '%s' "$uc_stat" | grep -oE '[0-9]+ deletion'  | grep -oE '[0-9]+' | head -1)
  : "${uc_add:=0}" "${uc_del:=0}"

  for cand in origin/main origin/master main master; do
    if git rev-parse --verify --quiet "$cand" >/dev/null 2>&1; then
      main_name="${cand##*/}"
      # skip if we ARE the main branch
      [ "$git_branch" = "$main_name" ] && { main_name=""; break; }
      dm_stat=$(git diff "${cand}...HEAD" --shortstat 2>/dev/null)
      dm_add=$(printf '%s' "$dm_stat" | grep -oE '[0-9]+ insertion' | grep -oE '[0-9]+' | head -1)
      dm_del=$(printf '%s' "$dm_stat" | grep -oE '[0-9]+ deletion'  | grep -oE '[0-9]+' | head -1)
      : "${dm_add:=0}" "${dm_del:=0}"
      break
    fi
  done
fi

DIV="$(C "$div_c") │ $(RST)"

# model
printf '🤖 %s%s %s%s' "$(C "$model_c")" "$model_short" "$ctx_tag" "$(RST)"

# fuel gauge — color ONLY the bar cells, not brackets or numbers
printf '%s' "$DIV"
printf '⛽ ['
[ -n "$filled_blocks" ] && printf '%s%s%s' "$(C "$gauge_c")" "$filled_blocks" "$(RST)"
[ -n "$empty_blocks" ]  && printf '%s%s%s' "$(C "$empty_c")" "$empty_blocks" "$(RST)"
printf '] %s/%s (%d%% used)' "$cur_k" "$max_k" "$pct_used"

# branch
if [ -n "$git_branch" ]; then
  printf '%s' "$DIV"
  printf '🌿 %s%s%s' "$(C "$branch_c")" "$git_branch" "$(RST)"
fi

# uncommitted
if [ "$uc_add" -gt 0 ] || [ "$uc_del" -gt 0 ]; then
  printf '%s' "$DIV"
  printf '✏️  %s+%d%s %s-%d%s' "$(C "$add_c")" "$uc_add" "$(RST)" "$(C "$del_c")" "$uc_del" "$(RST)"
fi

# delta from main (emoji-only label; branch segment to the left gives context)
if [ -n "$main_name" ] && { [ "$dm_add" -gt 0 ] || [ "$dm_del" -gt 0 ]; }; then
  printf '%s' "$DIV"
  printf '🔀 %s+%d%s %s-%d%s' \
    "$(C "$add_c")" "$dm_add" "$(RST)" \
    "$(C "$del_c")" "$dm_del" "$(RST)"
fi

printf '\n'
