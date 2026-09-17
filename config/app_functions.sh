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
elif grep -q "nobara" /etc/os-release; then
    system_os="Nobara"
elif grep -q "bazzite" /etc/os-release; then
    system_os="Bazzite"
elif grep -q "arch linux" /etc/os-release; then
    system_os="Arch Linux"
elif grep -q "cachyos" /etc/os-release; then
    system_os="CachyOS"
elif grep -q "endeavouros" /etc/os-release; then
    system_os="EndeavourOS"
elif grep -q "manjaro" /etc/os-release; then
    system_os="Manjaro"
elif grep -q "garuda" /etc/os-release; then
    system_os="Garuda Linux"
else
    system_os="an unknown OS"
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

    1) Arch Silence                   6) Fluent
                                      7) Lavanda
  [ CURSOR ]                          8) Layan
                                      9) WhiteSur
    2) Bibata
                                    [ KDE ]
  [ ICON ]
                                     10) Fluent
    3) Reversal                      11) Lavanda
                                     12) Layan
  [ TERMINAL ]                       13) WhiteSur

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
    8) Copy wireguard scripts to /usr/local/sbin
    9) Copy fan-profile script to /usr/local/bin (only ASUS laptops!)

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

draw_warning() {
    if [[ "${system_os}" == "SteamOS" ]] || [[ "${system_os}" == "an unknown OS" ]] || [[ "${system_os}" == "Nobara" ]] || [[ "${system_os}" == "Bazzite" ]]; then
        echo -e "${red}Warning: ${white}You're running ${red}${system_os} ${white}which is considered ${red}incompatible${white}!"
        echo -e "         ${nocolor}Please use SteamOS Customizer instead."
    fi
}
