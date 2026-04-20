#!/usr/bin/env bash
set -euo pipefail

pkill -f "qs -c network" || true
sleep 0.5
qs -c network >/dev/null 2>&1 &
