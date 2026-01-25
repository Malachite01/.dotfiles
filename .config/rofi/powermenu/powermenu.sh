#!/usr/bin/env bash

## Author : Aditya Shakya (adi1090x)
## Github : @adi1090x
#
## Rofi   : Power Menu

# Current Theme
dir="$HOME/.config/rofi/powermenu/"
theme='style-1'

# CMDs
uptime="`uptime -p | sed -e 's/up //g'`"

# Options
lock=''
suspend=''
hibernate=''
reboot=''
shutdown=''
yes=''
no='󰜺'

# Rofi CMD
rofi_cmd() {
	rofi -dmenu \
		-p "" \
		-mesg " Uptime: $uptime" \
		-theme ${dir}/${theme}.rasi
}

# Confirmation CMD
confirm_cmd() {
  rofi -dmenu \
    -theme ${dir}/${theme}.rasi \
    -theme-str '
      window {
        fullscreen: true;
        background-color: rgba(29, 32, 33, 0.75);
      }

      mainbox {
        padding: 35% 45% 35% 45%;
        children: [ "dummy", "box", "dummy2" ];
        orientation: vertical;
      }

      dummy, dummy2 {
        expand: true;
        background-color: transparent;
      }

      listview {
        columns: 2;
        lines: 1;
        fixed-columns: true;
        fixed-height: true;
      }
    ' \
    -p 'Confirmation' \
    -mesg 'Are you sure?'
}


# Ask for confirmation
confirm_exit() {
	echo -e "$yes\n$no" | confirm_cmd
}

# Pass variables to rofi dmenu
run_rofi() {
	echo -e "$lock\n$suspend\n$hibernate\n$reboot\n$shutdown" | rofi_cmd
}

# Execute Command
run_cmd() {
	selected="$(confirm_exit)"
	if [[ "$selected" == "$yes" ]]; then
		if [[ $1 == '--shutdown' ]]; then
			systemctl poweroff
		elif [[ $1 == '--reboot' ]]; then
			systemctl reboot
		elif [[ $1 == '--hibernate' ]]; then
			systemctl hibernate
		elif [[ $1 == '--suspend' ]]; then
			mpc -q pause
			amixer set Master mute
			systemctl suspend
		fi
	else
		exit 0
	fi
}

# Actions
chosen="$(run_rofi)"
case ${chosen} in
    $shutdown)
		run_cmd --shutdown
        ;;
    $reboot)
		run_cmd --reboot
        ;;
    $hibernate)
		run_cmd --hibernate
        ;;
    $lock)
		if [[ -x '/usr/bin/betterlockscreen' ]]; then
			betterlockscreen -l
		elif [[ -x '/usr/bin/i3lock' ]]; then
			i3lock
		fi
        ;;
    $suspend)
		run_cmd --suspend
        ;;
esac