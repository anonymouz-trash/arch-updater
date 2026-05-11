#!/usr/bin/bash

WG_INTERFACE_NAME="wg0" # <-- Set your correct configuration filename from /etc/wireguard, e.g. wg0.conf
WIFI_INTERFACE="wlan0"  # <-- Set your correct wifi device name. (ip -c a)

enable_secure_dns() {

    # dnsforge and quad9 DoT
    sudo resolvectl dns "$WIFI_INTERFACE" 176.9.93.198 9.9.9.9
    sudo resolvectl dnsovertls "$WIFI_INTERFACE" yes

}

disable_secure_dns() {

    # DHCP / Router DNS reset
    sudo resolvectl revert "$WIFI_INTERFACE"

}

# Check if WireGuard is active
if ip link show "$WG_INTERFACE_NAME" &>/dev/null; then

    # deactivate VPN
    pkexec wg-quick down "$WG_INTERFACE_NAME" && \
    enable_secure_dns && \
    notify-send -t 5000 -i "dialog-information" \
    "WireGuard VPN" \
    "$WG_INTERFACE_NAME disconnected | Secure DNS enabled"

else

    # activate VPN
    pkexec wg-quick up "$WG_INTERFACE_NAME" && \
    disable_secure_dns && \
    notify-send -t 5000 -i "dialog-information" \
    "WireGuard VPN" \
    "$WG_INTERFACE_NAME connected | Secure DNS disabled"

fi
