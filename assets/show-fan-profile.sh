#!/usr/bin/bash
MODE=$(cat /sys/devices/platform/asus-nb-wmi/fan_boost_mode)
if [ $MODE = '0' ]; then
    MODE="Default / Balanced"
elif [ $MODE = '1' ]; then
    MODE="Overboost"
elif [ $MODE = '2' ]; then
    MODE="Silent"
else
    MODE="Unknown"
fi

ICON="dialog-information"

if ! command -v notify-send &> /dev/null ; then
	pkexec pacman -S libnotify
fi
notify-send -t 5000 -i "$ICON" "Current Fan Speed Profile" "$MODE"
