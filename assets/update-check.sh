#!/usr/bin/env bash
#
# update-check.sh
#
# Prüft auf verfügbare Pacman- und (optional) AUR-Updates, ohne root-Rechte
# und ohne die echte Paketdatenbank anzufassen.
#
# - Offizielle Repos: nutzt `checkupdates` aus pacman-contrib. Das Tool
#   synct sich intern per `fakeroot` eine Kopie der DB nach
#   $XDG_CACHE_HOME/checkupdates (bzw. ~/.cache/checkupdates) und vergleicht
#   dagegen. Kein sudo, kein Anfassen von /var/lib/pacman.
# - AUR: `yay -Qua` (oder paru/pikaur), braucht ohnehin keinen fakeroot-Trick,
#   da es nur gegen die AUR-RPC-API vergleicht.
# - Flatpak: `flatpak remote-ls --updates`, nur falls flatpak installiert ist.
#   Vorher `flatpak update --appstream` zum stillen Refresh der Metadaten,
#   damit das Ergebnis nicht auf veraltetem Cache basiert.
#
# Exit codes:
#   0 = keine Updates
#   1 = Updates gefunden
#   2 = Fehler (z.B. checkupdates fehlt)

set -euo pipefail

STATE_DIR="${XDG_STATE_HOME:-$HOME/.local/state}/update-check"
LOG_FILE="$STATE_DIR/last-check.log"
NOTIFY="${UPDATE_CHECK_NOTIFY:-1}"   # 1 = notify-send nutzen, falls vorhanden

mkdir -p "$STATE_DIR"

pacman_updates=""
aur_updates=""
flatpak_updates=""

if command -v checkupdates >/dev/null 2>&1; then
    # checkupdates gibt exit 2 zurück, wenn keine Updates da sind - das ist
    # kein Fehlerfall für uns, daher `|| true`.
    pacman_updates="$(checkupdates 2>>"$LOG_FILE" || true)"
else
    echo "checkupdates nicht gefunden (pacman-contrib installiert?)" >>"$LOG_FILE"
fi

if command -v yay >/dev/null 2>&1; then
    aur_updates="$(yay -Qua 2>>"$LOG_FILE" || true)"
fi

if command -v flatpak >/dev/null 2>&1; then
    flatpak update --appstream >>"$LOG_FILE" 2>&1 || true
    flatpak_updates="$(flatpak remote-ls --updates --columns=application,version 2>>"$LOG_FILE" || true)"
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
    if [[ -n "$flatpak_updates" ]]; then
        echo "--- Flatpak ---"
        echo "$flatpak_updates"
    fi
} >>"$LOG_FILE"

pacman_count=0
aur_count=0
flatpak_count=0
[[ -n "$pacman_updates" ]] && pacman_count="$(wc -l <<<"$pacman_updates")"
[[ -n "$aur_updates" ]] && aur_count="$(wc -l <<<"$aur_updates")"
[[ -n "$flatpak_updates" ]] && flatpak_count="$(wc -l <<<"$flatpak_updates")"
total=$((pacman_count + aur_count + flatpak_count))

if (( total > 0 )); then
    msg="$total Update(s) verfügbar (Pacman: $pacman_count, AUR: $aur_count, Flatpak: $flatpak_count)"
    echo "$msg"
    if [[ "$NOTIFY" == "1" ]] && command -v notify-send >/dev/null 2>&1; then
        # -t 0: kein Timeout, bleibt sichtbar + landet zuverlässig im
        #       Plasma-Benachrichtigungsverlauf statt nach ein paar
        #       Sekunden spurlos zu verschwinden.
        # -u critical: wird nicht automatisch weggeräumt.
        notify-send -a "update-check" -u critical -t 0 \
            -i software-update-available \
            "Updates verfügbar" "$msg"
    fi
    exit 1
else
    echo "System ist aktuell."
    exit 0
fi
