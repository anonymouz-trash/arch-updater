#!/usr/bin/env bash
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

draw_logo() {
    echo -e "${blue}"
    cat << "EOF"

    ___              __       __  __          __      __
   /   |  __________/ /_     / / / /___  ____/ /___ _/ /____  _____
  / /| | / ___/ ___/ __ \   / / / / __ \/ __  / __ `/ __/ _ \/ ___/
 / ___ |/ /  / /__/ / / /  / /_/ / /_/ / /_/ / /_/ / /_/  __/ /
/_/  |_/_/   \___/_/ /_/   \____/ .___/\__,_/\__,_/\__/\___/_/
                               /_/
EOF
    echo -e "${nocolor}"
}

draw_main_menu() {
    echo -e "${white}"
    cat << EOF
========================================================================

  1) Update ${system_os} (yay/pacman + flatpaks)
  2) Update Mirrorlist (reflector)
  3) Clean ${system_os}

  4) >> Customization
  5) >> Optimizations & Tweaks
  6) >> Settings / Environment

  7) Credits

  q) Exit

========================================================================
EOF
    echo -e "${nocolor}"
}

draw_cust_menu() {
    echo -e "${white}"
    cat << "EOF"
========================================================================

  [ GRUB ]                          [ GTK ]

    1) Arch Silence                   5) Fluent
                                      6) Lavanda
  [ CURSOR ]                          7) Layan
                                      8) WhiteSur
    2) Bibata
                                    [ KDE ]
  [ ICON ]
                                      9) Fluent
    3) Reversal                      10) Lavanda
                                     11) Layan
  [ TERMINAL ]                       12) WhiteSur

    4) Fastfetch + Config
    5) OhMyZSH!

  b) Back
  q) Exit

========================================================================
EOF
    echo -e "${nocolor}"
}

draw_opt_menu() {
    echo -e "${white}"
    cat << EOF
========================================================================

  [ Repositories ]

    1) Install/Remove Chaotic (precompiled AUR packages)
    2) Install/Remove CachyOS (gaming optimized packages)

  [ Gaming Optimizations]

    3) Launch archgaming script by xi-Rick
    4) Launch Non-Steam-Launchers script by moraroy
    5) Install additional Windows fonts

  [ Prepare a freshly installed system ]

    6) Install additional pacman / yay / cachyos packages
    7) Install iptables with preconfigured ruleset

  [ Global hotkey scripts ]
    7) Copy wireguard scripts to /usr/local/sbin
    8) Copy fan-profile script to /usr/local/bin (only ASUS laptops!)

  b) Back
  q) Exit

========================================================================
EOF
    echo -e "${nocolor}"
}

draw_settings_menu() {
    echo -e "${white}"
    cat << "EOF"
========================================================================

  [ Script environment ]

    1) Show / Set reflector settings
    2) Show environment variables

  [ System ]

    3) Check for script updates
    4) Show installed packages from official repos
    5) Show installed packages from AUR (Arch User Repository)

  b) Back
  q) Exit

========================================================================
EOF
    echo -e "${nocolor}"
}

draw_credits_menu() {
    echo -e "${white}"
    cat << "EOF"
========================================================================

Credits & Thanks ar going to:

  [ Arch Silence GRUB Theme ] https://www.pling.com/p/1111545
  [   Reversal Icon Theme   ] https://github.com/yeyushengfan258/
  [   GTK/KDE/Icon Themes   ] https://github.com/vinceliuice
  [   Bibata Cursor Theme   ] https://github.com/ful1e5/Bibata_Cursor
  [    Fastfetch config     ] https://github.com/fastfetch-cli/fastfetch
  [       OhMyZsh!          ] https://github.com/ohmyzsh/ohmyzsh
  [    archgaming script    ] https://github.com/xi-Rick/archgaming
  [    NonSteamLaunchers    ] https://github.com/moraroy/NonSteamLaunchers-On-Steam-Deck

  b) Back
  q) Exit

========================================================================
EOF
    echo -e "${nocolor}"
}
