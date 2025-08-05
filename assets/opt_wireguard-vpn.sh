#!/usr/bin/bash

# Specifiy the Wireguard interface (config) name
WG_INTERFACE_NAME=wg0

# First check if the output of 'ip link' contains the Wireguard interface
if [ $(ip l | grep "$WG_INTERFACE_NAME" | wc -l) -eq 0 ]; then
	# Wireguard gets started.
	# && means success notify
	# || means any error
	pkexec resolvconf -u && wg-quick up wg0 && notify-send -t 5000 -i "dialog-information" "Wireguard VPN" "$WG_INTERFACE_NAME is connected..." || notify-send -u critical -t 5000 -i "dialog-warning" "Wireguard VPN" "Something went wrong!"

else
	pkexec wg-quick down wg0 && nmcli connection reload && notify-send -t 5000 -i "dialog-information" "Wireguard VPN" "$WG_INTERFACE_NAME is disconnected..." || notify-send -u critical -t 5000 -i "dialog-warning" "Wireguard VPN" "Something went wrong!"
fi
