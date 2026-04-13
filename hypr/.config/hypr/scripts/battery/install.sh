#!/bin/bash
set -e

SCRIPT_SRC="$HOME/.config/hypr/scripts/battery/battery-ac.sh"
SCRIPT_DST="/usr/local/bin/battery-ac.sh"

echo "➡ Installation battery-ac"

sudo install -Dm755 "$SCRIPT_SRC" "$SCRIPT_DST"

sudo tee /etc/systemd/system/battery-ac.service >/dev/null <<EOF
[Unit]
Description=Battery / AC profile switch

[Service]
Type=oneshot
ExecStart=$SCRIPT_DST
EOF

sudo tee /etc/udev/rules.d/99-battery-ac.rules >/dev/null <<EOF
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="0", RUN+="/bin/systemctl start battery-ac.service"
SUBSYSTEM=="power_supply", ENV{POWER_SUPPLY_ONLINE}=="1", RUN+="/bin/systemctl start battery-ac.service"
EOF

sudo systemctl daemon-reload
sudo udevadm control --reload
sudo udevadm trigger

sudo loginctl enable-linger pandora
echo "Installation terminée"
