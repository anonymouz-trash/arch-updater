#!/usr/bin/env bash
set -euo pipefail

# important for systemd User Services
export DISPLAY=${DISPLAY:-:0}
export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}

TITLE="Updates availabe"
BODY=()

# ---- Pacman / Yay ----
if command -v yay >/dev/null 2>&1; then
    UPDATES=$(yay -Qu 2>/dev/null || true)
elif command -v checkupdates >/dev/null 2>&1; then
    UPDATES=$(checkupdates 2>/dev/null || true)
else
    UPDATES=""
fi

if [[ -n "$UPDATES" ]]; then
    COUNT=$(echo "$UPDATES" | wc -l)
    BODY+=("📦 $COUNT Systempackages")
fi

# ---- Flatpak ----
if command -v flatpak >/dev/null 2>&1; then
    FLATPAK_UPDATES=$(flatpak remote-ls --updates 2>/dev/null || true)
    if [[ -n "$FLATPAK_UPDATES" ]]; then
        COUNT=$(echo "$FLATPAK_UPDATES" | wc -l)
        BODY+=("📦 $COUNT Flatpak packages")
    fi
fi

# ---- Notification ----
if (( ${#BODY[@]} > 0 )); then
    notify-send \
        --icon=system-software-update \
        --urgency=normal \
        "$TITLE" \
        "$(printf "%s\n" "${BODY[@]}")"
fi

