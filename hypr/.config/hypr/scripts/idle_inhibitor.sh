#!/usr/bin/env bash
STATE_FILE="/tmp/hypr-caffeine-state"

if [[ -f "$STATE_FILE" ]]; then
  rm "$STATE_FILE"
else
  touch "$STATE_FILE"
fi
