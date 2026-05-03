#!/bin/bash
STATE_FILE="/tmp/hypr-night-state"

if [[ -f "$STATE_FILE" ]]; then
  hyprctl hyprsunset identity
  rm "$STATE_FILE"
else
  hyprctl hyprsunset temperature 3500
  touch "$STATE_FILE"
fi
