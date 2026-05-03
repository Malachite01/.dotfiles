#!/bin/bash
PROFILES=("laptop-battery-powersave" "balanced-battery" "desktop" "throughput-performance")
BOOST=(0 0 1 1)

apply() {
  local idx=$1
  tuned-adm profile "${PROFILES[$idx]}"
  echo "${BOOST[$idx]}" | sudo tee /sys/devices/system/cpu/cpufreq/boost >/dev/null
}

if [[ -n "$1" ]]; then
  for i in "${!PROFILES[@]}"; do
    [[ "${PROFILES[$i]}" == "$1" ]] && apply "$i" && exit 0
  done
  exit 1
fi

# Sans argument : cycle
CUR=$(tuned-adm active | awk '{print $NF}')
IDX=0
for i in "${!PROFILES[@]}"; do
  [[ "${PROFILES[$i]}" == "$CUR" ]] && IDX=$i && break
done
apply $(((IDX + 1) % ${#PROFILES[@]}))
