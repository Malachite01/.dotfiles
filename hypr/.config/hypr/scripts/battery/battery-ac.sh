#!/bin/bash
set -e

AC_STATUS=$(cat /sys/class/power_supply/AC/online)

if [[ "$AC_STATUS" == "1" ]]; then
  PROFILE="desktop"
  tuned-adm profile "$PROFILE"
  echo 1 >/sys/devices/system/cpu/cpufreq/boost
else
  PROFILE="laptop-battery-powersave"
  tuned-adm profile "$PROFILE"
  echo 0 >/sys/devices/system/cpu/cpufreq/boost
fi
