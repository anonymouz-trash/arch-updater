#!/usr/bin/env bash

### Declare environment variables

# User home directory
app_home=$HOME

# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
app_pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${app_pwd}

export DIALOGRC="$app_pwd/config/dialogrc"

### Include required functions
source ./config/app_functions.sh
source ./config/app_methods.sh
source ./config/cust_methods.sh
source ./config/opt_methods.sh

check_4_dialog

while true; do
  # Check if arch-updater cache directory exists
  if ! [ -d "~/.cache/arch-updater" ]; then
    mkdir -p ~/.cache/arch-updater
  fi
  cd ${app_pwd}
  CHOICE=$(dialog --clear --colors \
    --backtitle "\Z5 Arch Linux Updater \Zn" \
    --title "\Z6 Main Menu \Zn" \
    --menu "Choose an option:" 20 70 12 \
      1 "Update Arch Linux (yay)" \
      2 "Update Arch Linux (pacman)" \
      3 "Update Mirrorlist (reflector)" \
      4 "Update debtap database" \
      5 "Clean Arch Linux" \
      6 "All above at once" \
      7 ">> Customization submenu" \
      8 ">> Optimizations & Tweaks submenu" \
      9 "Settings / Environment" \
      10 "Credits" \
      11 "Check for updates (script)" \
      q "Quit" \
    2>&1 >/dev/tty)

  clear
  case "$CHOICE" in
    1) update_yay ;;
    2) update_pacman ;;
    3) update_mirrorlist ;;
    4) update_debtap ;;
    5) clean_arch ;;
    6)
       update_mirrorlist
       update_yay
       update_debtap
       clean_arch
       ;;
    7)
       # Beispiel Untermenü: Customization
       SUB=$(dialog --clear --colors \
         --backtitle "\Z5 Arch Linux Updater \Zn" \
         --title "\Z6 Customization \Zn" \
         --menu "Choose customization option:" 20 70 12 \
           1 "Arch Silence GRUB Theme" \
           2 "Reversal Icon Theme" \
           3 "Lavanda KDE/GTK theme" \
           4 "Layan KDE/GTK theme" \
           5 "WhiteSur KDE/GTK theme" \
           6 "Bibata cursor theme" \
           b "Back" \
           q "Quit" \
         2>&1 >/dev/tty)
       case "$SUB" in
         1) cust_simple-arch-grub-theme ;;
         2) cust_reversal ;;
         3) cust_lavanda ;;
         4) cust_layan ;;
         5) cust_whitesur ;;
         6) cust_bibata ;;
         b) continue ;;
         q) exit ;;
         *) continue ;;
       esac
       ;;
    8)
       # Submenu: Optimizations & Tweaks — analog
       SUB=$(dialog --clear --colors \
         --backtitle "\Z5 Arch Linux Updater \Zn" \
         --title "\Z6 Optimizations \Zn" \
         --menu "Choose optimization option:" 20 70 12 \
           1 "Install/Remove Chaotic (precompiled AUR packages)" \
           2 "Install/Remove CachyOS (gaming optimized packages)" \
           3 "Launch archgaming script by xi-Rick" \
           4 "Launch Non-Steam-Launchers script by moraroy" \
           5 "Install additional pacman / yay / cachyos packages" \
           6 "Install additional Windows fonts" \
           7 "Copy wireguard scripts to /usr/local/sbin" \
           8 "Copy fan-profile script to /usr/local/bin" \
           b "Back" \
           q "Quit" \
         2>&1 >/dev/tty)
       case "$SUB" in
         1) opt_chaotic ;;
         2) opt_cachyos ;;
         3) opt_archgaming ;;
         4) opt_nsl ;;
         5) opt_packages ;;
         6) opt_fonts ;;
         7) opt_wireguard-sh ;;
         8) opt_fan-profile-sh ;;
         b) continue ;;
         q) exit ;;
         *) continue ;;
       esac
       ;;
    9)
       # Settings / Environment submenu
       SUB=$(dialog --clear --colors \
         --backtitle "\Z5 Arch Linux Updater \Zn" \
         --title "\Z6 Settings \Zn" \
         --menu "Choose option:" 15 60 6 \
           1 "Set reflector settings" \
           2 "Show environment variables" \
           b "Back" \
           q "Quit" \
         2>&1 >/dev/tty)
       case "$SUB" in
         1) set_reflector ;;
         2) dialog --clear --colors --msgbox "Environment variables:\n\n \
\Z5Script path\Zn = ${app_pwd}\n \
\Z5User home\Zn   = ${app_home}\n \
\Z5Desktop\Zn     = ${de,,}\n \
\Z5Shell\Zn       = $SHELL \Z1(if it's false, reboot)\Zn" 15 60 ;;
         b) continue ;;
         q) exit ;;
         *) continue ;;
       esac
       ;;
    10)
       # Credits — z. B. msgbox
       dialog --clear --colors --msgbox "Credits & Thanks:\n\n \
\Z5Arch Silence GRUB Theme\Zn\n \
   https://www.pling.com/p/1111545\n\n \
\Z5Reversal Icon Theme\Zn\n \
   https://github.com/yeyushengfan258/Reversal-icon-theme\n\n \
\Z5GTK/KDE/Icon Themes\Zn\n \
   https://github.com/vinceliuice\n\n \
\Z5Bibata Cursor Theme\Zn\n \
   https://github.com/ful1e5/Bibata_Cursor\n\n \
\Z5My own Fastfetch Preset Fork from examples\Zn\n \
   https://github.com/fastfetch-cli/fastfetch\n\n \
\Z5OhMyZsh!\Zn\n \
   https://github.com/ohmyzsh/ohmyzsh\n\n \
\Z5archgaming script\Zn\n \
   https://github.com/xi-Rick/archgaming\n\n \
\Z5NonSteamLaunchers on Steam Deck\Zn\n \
   https://github.com/moraroy/NonSteamLaunchers-On-Steam-Deck\n\n" 30 70
       ;;
    11)
       git pull 2>&1 | dialog --title "<[ Running script update... ]>" --colors --progressbox 20 70
       sleep 5
       dialog --clear --colors --msgbox "If script got updated please restart the script." 6 60
       ;;
    q) break ;;
    *) break ;;
  esac
done

clear
echo "Goodbye."
