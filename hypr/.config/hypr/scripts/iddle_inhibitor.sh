#!/usr/bin/env bash
STATE_FILE="/tmp/hypr-caffeine-state"

if [[ -f "$STATE_FILE" ]]; then
  notify-send "  Inhibiteur inactif"
  rm "$STATE_FILE"
else
  notify-send "  Inhibiteur actif"
  touch "$STATE_FILE"
fi
