#!/usr/bin/bash

# Specifiy the Wireguard interface (config) name
WG_INTERFACE_NAME=wg0

# First check if the output of 'ip link' contains the Wireguard interface
if [ $(ip l | grep "$WG_INTERFACE_NAME" | wc -l) -ne 0 ]; then

  # If the result is true, then it will try to shutdown the Wireguard interface and redirect the error channel
  # to STDOUT and put it into the $TMP variable (if there went anything wrong).
  if pkexec wg-quick down wg0 2>&1 | tee $TMP; then
    
    # If anything went ok then a notification is shown like below.
    notify-send -t 5000 -i "dialog-information" "Wireguard VPN" "$WG_INTERFACE_NAME is not connected"
  else

    # If there went anything wrong then it will be shown in a warning dialog contain the error message.    
    notify-send -u critical -t 5000 -i "dialog-warning" "Wireguard VPN" "$TMP"
    rm $TMP
  fi
  exit 1
else

  # Same as above but the order of operation is the opposite.
  if pkexec wg-quick up wg0 2>&1 | tee $TMP; then
    notify-send -t 5000 -i "dialog-information" "Wireguard VPN" "$WG_INTERFACE_NAME is connected"
  else
    notify-send -u critical -t 5000 -i "dialog-warning" "Wireguard VPN" "$TMP"
    rm $TMP
  fi
  exit 1
fi