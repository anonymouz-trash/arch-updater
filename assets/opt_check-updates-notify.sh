#!/usr/bin/env bash
set -euo pipefail

# Environment for systemd user services
export DISPLAY=${DISPLAY:-:0}
export DBUS_SESSION_BUS_ADDRESS=${DBUS_SESSION_BUS_ADDRESS:-unix:path=/run/user/$(id -u)/bus}

TITLE="System updates available"
LINES=()

MAX_LINES=10

# ---- Yay / Pacman (Top 10, detailed) ----
if command -v yay >/dev/null 2>&1; then
    UPDATES=$(yay -Qu 2>/dev/null || true)
elif command -v checkupdates >/dev/null 2>&1; then
    UPDATES=$(checkupdates 2>/dev/null || true)
else
    UPDATES=""
fi

if [[ -n "$UPDATES" ]]; then
    TOTAL=$(echo "$UPDATES" | wc -l)
    TOP=$(echo "$UPDATES" | head -n "$MAX_LINES")

    LINES+=("📦 $TOTAL system package updates")
    LINES+=("")
    LINES+=("$TOP")

    if (( TOTAL > MAX_LINES )); then
        LINES+=("")
        LINES+=("…and $((TOTAL - MAX_LINES)) more")
    fi
fi

# ---- Flatpak (Top 10, detailed) ----
if command -v flatpak >/dev/null 2>&1; then
    FLATPAK_UPDATES=$(flatpak update --app --assumeno 2>/dev/null \
        | awk '/->/ {print $1 " (" $NF ")"}' \
        | head -n 10 || true)

    if [[ -n "$FLATPAK_UPDATES" ]]; then
        TOTAL=$(flatpak update --app --assumeno 2>/dev/null | awk '/->/' | wc -l)

        LINES+=("")
        LINES+=("📦 $TOTAL Flatpak updates")
        LINES+=("")
        LINES+=("$FLATPAK_UPDATES")

        if (( TOTAL > 10 )); then
            LINES+=("")
            LINES+=("…and $((TOTAL - 10)) more")
        fi
    fi
fi


# ---- Notification ----
if (( ${#LINES[@]} > 0 )); then
    notify-send \
        --icon=system-software-update \
        --urgency=critical \
        "$TITLE" \
        "$(printf "%s\n" "${LINES[@]}")"
fi
