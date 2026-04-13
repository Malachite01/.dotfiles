#!/bin/bash
# Usage: ./power-switch-menu.sh [profile]
# Profiles list
PROFILES=("laptop-battery-powersave" "balanced-battery" "default" "throughput-performance")

# Function to set boost according to profile
set_boost() {
  local prof="$1"
  case "$prof" in
    "laptop-battery-powersave" | "balanced-battery")
      echo 0 | sudo tee /sys/devices/system/cpu/cpufreq/boost
      ;;
    "default" | "throughput-performance")
      echo 1 | sudo tee /sys/devices/system/cpu/cpufreq/boost
      ;;
  esac
}

# Function to check if profile exists
profile_exists() {
  local prof="$1"
  for p in "${PROFILES[@]}"; do
    [[ "$p" == "$prof" ]] && return 0
  done
  return 1
}

# Switch to specific profile if argument given
if [[ -n "$1" ]]; then
  NEW_PROFILE="$1"
  if ! profile_exists "$NEW_PROFILE"; then
    echo "Profile not recognized!"
    exit 1
  fi
else
  # Cycle to next profile
  CUR_PROFILE=$(tuned-adm active | awk '{print $NF}')
  IDX=-1
  for i in "${!PROFILES[@]}"; do
    if [[ "${PROFILES[$i]}" == "$CUR_PROFILE" ]]; then
      IDX=$i
      break
    fi
  done
  if [[ $IDX -eq -1 ]]; then IDX=0; fi
  NEXT_IDX=$(((IDX + 1) % ${#PROFILES[@]}))
  NEW_PROFILE="${PROFILES[$NEXT_IDX]}"
fi

# Apply
tuned-adm profile "$NEW_PROFILE"
set_boost "$NEW_PROFILE"
notify-send -a Battery -i battery "  " "$NEW_PROFILE"
