#!/usr/bin/env bash
set -euo pipefail

mode="${1:-bluetooth}"
case "$mode" in
	network|wifi)
		qs_mode="wifi"
		;;
	bluetooth|bt)
		qs_mode="bt"
		;;
	-h|--help)
		echo "Usage: $0 [network|bluetooth]"
		exit 0
		;;
	*)
		echo "Invalid mode: $mode" >&2
		echo "Usage: $0 [network|bluetooth]" >&2
		exit 1
		;;
esac

pkill -f "qs -c network" || true
sleep 0.5
QS_NETWORK_MODE="$qs_mode" qs -c network >/dev/null 2>&1 &
