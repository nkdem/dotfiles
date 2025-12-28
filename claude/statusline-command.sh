#!/bin/bash
config_file="$HOME/.claude/statusline-config.txt"
if [ -f "$config_file" ]; then
  source "$config_file"
  show_dir=$SHOW_DIRECTORY
  show_branch=$SHOW_BRANCH
  show_usage=$SHOW_USAGE
  show_bar=$SHOW_PROGRESS_BAR
  show_weekly=${SHOW_WEEKLY:-1}
else
  show_dir=1
  show_branch=1
  show_usage=1
  show_bar=1
  show_weekly=1
fi

input=$(cat)
current_dir_path=$(echo "$input" | grep -o '"current_dir":"[^"]*"' | sed 's/"current_dir":"//;s/"$//')
current_dir=$(basename "$current_dir_path")
BLUE=$'\033[0;34m'
GREEN=$'\033[0;32m'
GRAY=$'\033[0;90m'
YELLOW=$'\033[0;33m'
RESET=$'\033[0m'

# 10-level gradient: dark green → deep red
LEVEL_1=$'\033[38;5;22m'   # dark green
LEVEL_2=$'\033[38;5;28m'   # soft green
LEVEL_3=$'\033[38;5;34m'   # medium green
LEVEL_4=$'\033[38;5;100m'  # green-yellowish dark
LEVEL_5=$'\033[38;5;142m'  # olive/yellow-green dark
LEVEL_6=$'\033[38;5;178m'  # muted yellow
LEVEL_7=$'\033[38;5;172m'  # muted yellow-orange
LEVEL_8=$'\033[38;5;166m'  # darker orange
LEVEL_9=$'\033[38;5;160m'  # dark red
LEVEL_10=$'\033[38;5;124m' # deep red

# Build components (without separators)
dir_text=""
if [ "$show_dir" = "1" ]; then
  dir_text="${BLUE}${current_dir}${RESET}"
fi

branch_text=""
if [ "$show_branch" = "1" ]; then
  if git rev-parse --git-dir > /dev/null 2>&1; then
    branch=$(git branch --show-current 2>/dev/null)
    [ -n "$branch" ] && branch_text="${GREEN}⎇ ${branch}${RESET}"
  fi
fi

usage_text=""

# Model detection
model_text=""
settings_file="$HOME/.config/claude/settings.json"
if [ -f "$settings_file" ]; then
  model_value=$(grep -o '"model"[[:space:]]*:[[:space:]]*"[^"]*"' "$settings_file" | sed 's/"model"[[:space:]]*:[[:space:]]*"//;s/"$//')

  if [ "$model_value" = "opus" ]; then
    model_text="${YELLOW}Opus${RESET}"
  elif [ "$model_value" = "haiku" ]; then
    model_text="${GREEN}Haiku${RESET}"
  else
    # Default is Sonnet (when not specified or any other value)
    model_text="${BLUE}Sonnet${RESET}"
  fi
else
  # If settings.json doesn't exist, default to Sonnet
  model_text="${BLUE}Sonnet${RESET}"
fi

# Helper function to get color for utilization level
get_usage_color() {
  local util=$1
  if [ "$util" -le 10 ]; then
    echo "$LEVEL_1"
  elif [ "$util" -le 20 ]; then
    echo "$LEVEL_2"
  elif [ "$util" -le 30 ]; then
    echo "$LEVEL_3"
  elif [ "$util" -le 40 ]; then
    echo "$LEVEL_4"
  elif [ "$util" -le 50 ]; then
    echo "$LEVEL_5"
  elif [ "$util" -le 60 ]; then
    echo "$LEVEL_6"
  elif [ "$util" -le 70 ]; then
    echo "$LEVEL_7"
  elif [ "$util" -le 80 ]; then
    echo "$LEVEL_8"
  elif [ "$util" -le 90 ]; then
    echo "$LEVEL_9"
  else
    echo "$LEVEL_10"
  fi
}

# Helper function to build progress bar
build_progress_bar() {
  local util=$1
  local bar=" "
  local filled_blocks empty_blocks i

  if [ "$util" -eq 0 ]; then
    filled_blocks=0
  elif [ "$util" -ge 100 ]; then
    filled_blocks=10
  else
    filled_blocks=$(( (util * 10 + 50) / 100 ))
  fi
  [ "$filled_blocks" -lt 0 ] && filled_blocks=0
  [ "$filled_blocks" -gt 10 ] && filled_blocks=10
  empty_blocks=$((10 - filled_blocks))

  i=0
  while [ $i -lt $filled_blocks ]; do
    bar="${bar}▓"
    i=$((i + 1))
  done
  i=0
  while [ $i -lt $empty_blocks ]; do
    bar="${bar}░"
    i=$((i + 1))
  done
  echo "$bar"
}

# Helper function to format reset time
format_reset_time() {
  local resets_at=$1
  local reset_display=""

  if [ -n "$resets_at" ] && [ "$resets_at" != "null" ]; then
    # Handle timezone offset format (+00:00)
    iso_time=$(echo "$resets_at" | sed 's/\.[0-9]*+.*$//' | sed 's/\.[0-9]*Z$//')
    epoch=$(date -ju -f "%Y-%m-%dT%H:%M:%S" "$iso_time" "+%s" 2>/dev/null)

    if [ -n "$epoch" ]; then
      reset_time=$(date -r "$epoch" "+%I:%M %p" 2>/dev/null)
      [ -n "$reset_time" ] && reset_display=$(printf " → Reset: %s" "$reset_time")
    fi
  fi
  echo "$reset_display"
}

# Helper function to format weekly reset (day of week)
format_weekly_reset() {
  local resets_at=$1
  local reset_display=""

  if [ -n "$resets_at" ] && [ "$resets_at" != "null" ]; then
    iso_time=$(echo "$resets_at" | sed 's/\.[0-9]*+.*$//' | sed 's/\.[0-9]*Z$//')
    epoch=$(date -ju -f "%Y-%m-%dT%H:%M:%S" "$iso_time" "+%s" 2>/dev/null)

    if [ -n "$epoch" ]; then
      reset_day=$(date -r "$epoch" "+%A" 2>/dev/null)
      [ -n "$reset_day" ] && reset_display=$(printf " → Reset: %s" "$reset_day")
    fi
  fi
  echo "$reset_display"
}

if [ "$show_usage" = "1" ] || [ "$show_weekly" = "1" ]; then
  swift_result=$(swift "$HOME/.claude/fetch-claude-usage.swift" 2>/dev/null)

  if [ $? -eq 0 ] && [ -n "$swift_result" ]; then
    # Parse: FIVE_HOUR_UTIL|FIVE_HOUR_RESETS|SEVEN_DAY_UTIL|SEVEN_DAY_RESETS
    utilization=$(echo "$swift_result" | cut -d'|' -f1)
    resets_at=$(echo "$swift_result" | cut -d'|' -f2)
    weekly_util=$(echo "$swift_result" | cut -d'|' -f3)
    weekly_resets=$(echo "$swift_result" | cut -d'|' -f4)

    # Build 5-hour usage text
    if [ "$show_usage" = "1" ]; then
      if [ -n "$utilization" ] && [ "$utilization" != "ERROR" ]; then
        usage_color=$(get_usage_color "$utilization")

        if [ "$show_bar" = "1" ]; then
          progress_bar=$(build_progress_bar "$utilization")
        else
          progress_bar=""
        fi

        reset_time_display=$(format_reset_time "$resets_at")

        # If weekly is also enabled, combine them on one line
        if [ "$show_weekly" = "1" ] && [ -n "$weekly_util" ]; then
          weekly_color=$(get_usage_color "$weekly_util")

          if [ "$show_bar" = "1" ]; then
            weekly_bar=$(build_progress_bar "$weekly_util")
          else
            weekly_bar=""
          fi

          weekly_reset_display=$(format_weekly_reset "$weekly_resets")

          # Combined format: 5h: 12% ▓░░░░░░░░░ → 1PM  ╱  7d: 44% ▓▓▓▓░░░░░░ → Thu
          usage_text="${usage_color}5h:${utilization}%${progress_bar}${reset_time_display}${RESET} ${GRAY}╱${RESET} ${weekly_color}7d:${weekly_util}%${weekly_bar}${weekly_reset_display}${RESET}"
        else
          usage_text="${usage_color}Session: ${utilization}%${progress_bar}${reset_time_display}${RESET}"
        fi
      else
        usage_text="${YELLOW}Session: ~${RESET}"
      fi
    fi
  else
    [ "$show_usage" = "1" ] && usage_text="${YELLOW}Session: ~${RESET}"
  fi
fi

output=""
separator="${GRAY} │ ${RESET}"

[ -n "$dir_text" ] && output="${dir_text}"

if [ -n "$branch_text" ]; then
  [ -n "$output" ] && output="${output}${separator}"
  output="${output}${branch_text}"
fi

if [ -n "$usage_text" ]; then
  [ -n "$output" ] && output="${output}${separator}"
  output="${output}${usage_text}"
fi

if [ -n "$model_text" ]; then
  [ -n "$output" ] && output="${output}${separator}"
  output="${output}${model_text}"
fi

printf "%s\n" "$output"