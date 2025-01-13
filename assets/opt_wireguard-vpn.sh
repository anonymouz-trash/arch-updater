#!/usr/bin/bash
WG_INTERFACE_NAME=wg0
if [ $(ip l | grep "$WG_INTERFACE_NAME" | wc -l > /dev/null) -ne 0 ]; then
  pkexec wg-quick down wg0
  notify-send -t 5000 -i "$ICON" "Wireguard VPN" "$WG_INTERFACE_NAME is not connected"
  exit 1
else
  pkexec wg-quick up wg0
  notify-send -t 5000 -i "$ICON" "Wireguard VPN" "$WG_INTERFACE_NAME is connected"
  exit 1
fi
