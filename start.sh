#!/usr/bin/env bash

### Enable debugging
# set -x

### Declare environment variables

# User home directory
app_home=$HOME

# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
app_pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${app_pwd}

### Include required functions
source ./config/app_functions.sh
source ./config/app_methods.sh
source ./config/cust_methods.sh
source ./config/opt_methods.sh

### Check if a config is available
if ! [ -f ~/.config/arch_updater.conf ]; then
    set_reflector
fi

### Menu section
check_4_dialog

while true; do
  ### Check if a config is available
  if ! [ -f ~/.config/arch_updater.conf ]; then
    set_reflector
  fi
  # Check if arch-updater cache directory exists
  if ! [ -d "~/.cache/arch-updater" ]; then
    mkdir -p ~/.cache/arch-updater
  fi
  cd ${app_pwd}
  CHOICE=$(dialog --clear --colors \
    --backtitle "\Z5 Arch Linux Updater \Zn" \
    --title "\Z6 Main Menu \Zn" \
    --menu "Choose an option:" 20 70 12 \
      1 "Update Arch Linux (yay/pacman + flatpaks)" \
      2 "Update Mirrorlist (reflector)" \
      3 "Clean Arch Linux" \
      4 "All above at once" \
      5 ">> Customization submenu" \
      6 ">> Optimizations & Tweaks submenu" \
      7 ">> Steamdeck optimization submenu" \
      8 "Settings / Environment" \
      9 "Credits" \
      10 "Check for updates (script)" \
      q "Quit" \
    2>&1 >/dev/tty)

  clear
  case "$CHOICE" in
    1) update_arch ;;
    2) update_mirrorlist ;;
    3) clean_arch ;;
    4)
       update_mirrorlist
       update_arch
       clean_arch
       ;;
    5)
       if ! [[ "${system_os}" == "SteamOS" ]]; then
           # Beispiel Untermenü: Customization
           SUB=$(dialog --clear --colors \
             --backtitle "\Z5 Arch Linux Updater \Zn" \
             --title "\Z6 Customization \Zn" \
             --menu "Choose an option:" 20 70 12 \
               1 "Arch Silence GRUB Theme" \
               2 "Reversal Icon Theme" \
               3 "Lavanda KDE/GTK theme" \
               4 "Layan KDE/GTK theme" \
               5 "WhiteSur KDE/GTK theme" \
               6 "Bibata cursor theme" \
               7 "OhMyZsh! shell addon" \
               8 "Fastfetch config" \
               9 "Tmux config" \
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
             7) cust_ohmyzsh ;;
             8) cust_fastfetch ;;
             9) cust_tmux ;;
             b) continue ;;
             q) exit ;;
             *) continue ;;
           esac
       else
           dialog --clear --colors --msgbox "\Z1Important notice:\Zn\n\n \
This section is \Z5disabled\Zn for Steamdeck!\n\n" 10 65
       fi
       ;;
    6)
       if ! [[ "${system_os}" == "SteamOS" ]]; then
           # Submenu: Optimizations & Tweaks — analog
           SUB=$(dialog --clear --colors \
             --backtitle "\Z5 Arch Linux Updater \Zn" \
             --title "\Z6 Optimizations \Zn" \
             --menu "Choose an option:" 20 70 12 \
               1 "Install/Remove Chaotic (precompiled AUR packages)" \
               2 "Install/Remove CachyOS (gaming optimized packages)" \
               3 "Launch archgaming script by xi-Rick" \
               4 "Launch Non-Steam-Launchers script by moraroy" \
               5 "Install additional pacman / yay / cachyos packages" \
               6 "Install additional Windows fonts" \
               7 "Copy wireguard scripts to /usr/local/sbin" \
               8 "Copy fan-profile script to /usr/local/bin" \
               9 "Install iptables with preconfigured ruleset" \
              10 "Install update-checker service for '\Z5$USER\Zn'" \
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
               7) opt_wireguard ;;
               8) opt_fan-profile ;;
               9) opt_iptables ;;
              10) opt_check-updates-service ;;
               b) continue ;;
               q) exit ;;
               *) continue ;;
           esac
       else
           dialog --clear --colors --msgbox "\Z1Important notice:\Zn\n\n \
This section is \Z5disabled\Zn for Steamdeck!\n\n" 10 65
       fi
       ;;
    7)
       if [[ "${system_os}" == "SteamOS" ]]; then
           # Submenu: Steamdeck optimization submenu
           SUB=$(dialog --clear --colors \
           --backtitle "\Z5 Arch Linux Updater \Zn" \
           --title "\Z6 Steamdeck optimizations \Zn" \
           --menu "Choose an option:" 20 70 12 \
             1 "Enable password for 'deck' user to enable sudo" \
             2 "Enable Pacman repositories (normal)" \
             3 "Enable Pacman repositories (userspace) [\Z1experimental\Zn]" \
             4 "Install/Remove Chaotic (precompiled AUR packages)" \
             5 "Launch Non-Steam-Launchers script" \
             6 "Launch Decky Loader script" \
             7 "Install iptables with preconfigured ruleset" \
             8 "Install Fastfetch and apply custom config" \
             9 "Install Wireguard & copy wireguard scripts to /usr/local/sbin" \
            10 "Install update-checker service for '\Z5$USER\Zn'" \
             b "Back" \
             q "Quit" \
           2>&1 >/dev/tty)
           case "$SUB" in
             1) passwd ;;
             2) dialog --clear --colors --msgbox "\Z1Important notice:\Zn\n\n \
This will enable the \Z5pacman\Zn command \Z5system-wide\Zn!\n\n \
This also means:\n \
  * this workaround\n \
  * when Chaotic repo is enabled you may also install \Z5yay\Zn\n \
  * all installed packages\n\n \
will \Z5revert\Zn on every SteamOS system update!" 15 65
              opt_sd_pacman_normal ;;
             3) dialog --clear --colors --msgbox "\Z1Important notice:\Zn\n\n \
This will install the \Z5pacman\Zn command in \Z5userspace\Zn!\n\n \
This means:\n \
  * alias command is \Z5'pacman_'\Zn\n \
  * when Chaotic repo is enabled you may also install \Z5yay\Zn\n \
  * keep in mind that yay is \Z5not using 'pacman_'\Zn alias\n \
  * installing packages in \Z5'~/.root\Zn\n \
  * installed packages will survive SteamOS system update \n\n \
There \Z5maybe problems\Zn with 'falsly' linked libraries.\n \
Read \Z5https://www.jeromeswannack.com/projects/2024/11/29/steamdeck-userspace-pacman.html\Zn!" 20 95
              opt_sd_pacman_userspace ;;
             4) opt_chaotic ;;
             5) opt_nsl ;;
             6) opt_decky ;;
             7) opt_iptables ;;
             8) cust_fastfetch_steam ;;
             9) opt_wireguard-sh ;;
            10) opt_check-updates-service ;;
             b) continue ;;
             q) exit ;;
             *) continue ;;
           esac
       else
           dialog --clear --colors --msgbox "\Z1Important notice:\Zn\n\n \
This section is \Z5disabled\Zn for systems other than Steamdeck!\n\n" 10 65
       fi
      ;;
    8)
       # Settings / Environment submenu
       SUB=$(dialog --clear --colors \
         --backtitle "\Z5 Arch Linux Updater \Zn" \
         --title "\Z6 Settings \Zn" \
         --menu "Choose an option:" 15 60 6 \
           1 "Set reflector settings" \
           2 "Show environment variables" \
           b "Back" \
           q "Quit" \
         2>&1 >/dev/tty)
       case "$SUB" in
         1) set_reflector ;;
         2) dialog --clear --colors --msgbox "Environment variables:\n\n \
\Z6[System]\Zn\n \
  \Z5System OS\Zn       = ${system_os}\n \
  \Z5Desktop\Zn         = ${de,,}\n \
  \Z5Shell\Zn           = $SHELL \Z1(if it's false, reboot)\Zn\n \
  \Z5User home\Zn       = ${app_home}\n\n \
\Z6[Script]\Zn\n \
  \Z5Script path\Zn     = ${app_pwd}\n\n \
\Z6[Pacman]\Zn\n \
  \Z5Pacman cmd\Zn      = ${pacman_cmd} \n \
  \Z5Pacman-key cmd\Zn  = ${packey_cmd}\n \
  \Z5pacman.conf\Zn     = ${PACMAN_CONF}\n \
  \Z5pacman.d\Zn        = ${PACMAN_DIR}" 22 65 ;;
         b) continue ;;
         q) exit ;;
         *) continue ;;
       esac
       ;;
    9)
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
   https://github.com/moraroy/NonSteamLaunchers-On-Steam-Deck\n\n \
\Z5Steam Deck hacking: Setting up user space pacman\Zn\n
   https://www.jeromeswannack.com/projects/2024/11/29/steamdeck-userspace-pacman.html\n" 35 95
       ;;
    10)
       git pull 2>&1 | dialog --title "<[ Running script update... ]>" --colors --progressbox 20 70
       dialog --clear --colors --msgbox "If script got updated please restart the script." 6 60
       ;;
    q) break ;;
    *) break ;;
  esac
done

clear
echo "Goodbye."
