#!/usr/bin/bash
# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
# pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# colors section
blue='\033[1;34m'
cyan='\033[1;36m'
magenta='\033[1;35m'
red='\033[1;31m'
white='\033[1;37m'
nocolor='\033[0m'

# check current desktop
de=$XDG_CURRENT_DESKTOP

# check current linux system
if grep -q "steamos" /etc/os-release; then
    system_os="SteamOS"
elif grep -q "Arch Linux" /etc/os-release; then
    system_os="Arch Linux"
elif grep -q "CachyOS" /etc/os-release; then
    system_os="CachyOS"
elif grep -q "EndeavourOS" /etc/os-release; then
    system_os="EndeavourOS"
elif grep -q "Manjaro" /etc/os-release; then
    system_os="Manjaro"
elif grep -q "Garuda" /etc/os-release; then
    system_os="Garuda Linux"
else
    system_os="Something else (use at your own risk)"
fi

# set dialog theme
export DIALOGRC="$app_pwd/config/app_dialogrc"

# check if pacman_ alias exists (steamdeck)
if alias pacman_ &>/dev/null; then
    # Set up main variables
    USERROOT="/home/deck/.root"
    PACMAN_CONF="${USERROOT}/etc/pacman.conf"
    PACMAN_DIR="${USERROOT}/etc/pacman.d"
    GPG_DIR="${USERROOT}/etc/pacman.d/gnupg"
    pacman_cmd="pacman_ "
    packey_cmd="pacman-key --gpgdir "${GPG_DIR}""
else
    PACMAN_CONF="/etc/pacman.conf"
    PACMAN_DIR="/etc/pacman.d"
    pacman_cmd="pacman "
    packey_cmd="pacman-key "
fi

# check 4 yay
if ! command -v yay &> /dev/null ; then
    app_yay=0
else
    app_yay=1
fi

# check 4 flatpak
if ! command -v flatpak &> /dev/null ; then
    app_flatpak=0
else
    app_flatpak=1
fi
