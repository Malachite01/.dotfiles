#!/usr/bin/env bash
STATE_FILE="/tmp/hypr-caffeine-state"

if [[ -f "$STATE_FILE" ]]; then
  notify-send -a Caffeine -i idle " 󰒲 " "Idle on"
  rm "$STATE_FILE"
else
  notify-send -a Caffeine -i idle "  " "Idle off"
  touch "$STATE_FILE"
fi
