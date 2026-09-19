#!/usr/bin/env bash

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/update-check"
LOG_FILE="$STATE_DIR/last-check.log"
NOTIFY="${UPDATE_CHECK_NOTIFY:-1}"   # 1 = notify-send nutzen, falls vorhanden

mkdir -p "$STATE_DIR"

pacman_updates=""
aur_updates=""

if command -v checkupdates >/dev/null 2>&1; then
    pacman_updates="$(checkupdates 2>>"$LOG_FILE" || true)"
else
    echo "checkupdates not found (pacman-contrib installed?)" >>"$LOG_FILE"
fi

if command -v yay >/dev/null 2>&1; then
    aur_updates="$(yay -Qua 2>>"$LOG_FILE" || true)"
fi

{
    echo "=== Update-Check: $(date -Is) ==="
    if [[ -n "$pacman_updates" ]]; then
        echo "--- Pacman ---"
        echo "$pacman_updates"
    fi
    if [[ -n "$aur_updates" ]]; then
        echo "--- AUR ---"
        echo "$aur_updates"
    fi
} >>"$LOG_FILE"

pacman_count=0
aur_count=0
[[ -n "$pacman_updates" ]] && pacman_count="$(wc -l <<<"$pacman_updates")"
[[ -n "$aur_updates" ]] && aur_count="$(wc -l <<<"$aur_updates")"
total=$((pacman_count + aur_count))

if (( total > 0 )); then
    msg="$total Update(s) available (Pacman: $pacman_count, AUR: $aur_count)"
    echo "$msg"
    if [[ "$NOTIFY" == "1" ]] && command -v notify-send >/dev/null 2>&1; then
        notify-send -a "update-check" "Updates available" "$msg"
    fi
    exit 1
else
    echo "System is fresh."
    exit 0
fi
