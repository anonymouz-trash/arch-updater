#!/usr/bin/env bash

### Enable debugging
# set -Eeuo pipefail
# trap 'echo "ERROR in $0:${LINENO}: $BASH_COMMAND" >&2' ERR
# PS4='+ ${BASH_SOURCE}:${LINENO}: '
# set -x


### Declare environment variables

# User home directory
app_home=$HOME

# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
app_pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd "${app_pwd}"

### Include required functions
for f in ./config/{app_functions,app_methods,cust_methods,opt_methods}.sh; do
  [[ -f $f ]] || { echo "Missing $f" >&2; exit 1; }
  source "$f"
done

while true; do
  ### Check if a config is available
  if ! [ -f ~/.config/arch_updater.conf ]; then
    set_reflector
  fi
  # Check if arch-updater cache directory exists
  if ! [ -d "$HOME/.cache/arch-updater" ]; then
    mkdir -p ~/.cache/arch-updater
  fi
  cd ${app_pwd}
  clear
  draw_logo
  draw_warning
  draw_main_menu
  read -rp "Choice: " choice
  case $choice in
      1) update_arch ;;
      2) update_mirrorlist ;;
      3) clean_arch ;;
      4)
         clear
         draw_logo
         draw_cust_menu
         read -rp "Choice: " choice
         case $choice in
             1) cust_grub_arch_silence ;;
             2) cust_bibata ;;
             3) cust_reversal ;;
             4) cust_fastfetch ;;
             5) cust_ohmyzsh ;;
             6) cust_gtk_fluent ;;
             7) cust_gtk_lavanda ;;
             8) cust_gtk_layan ;;
             9) cust_gtk_whitesur ;;
            10) cust_kde_fluent ;;
            11) cust_kde_lavanda ;;
            12) cust_kde_layan ;;
            13) cust_kde_whitesur ;;
             b)
                 continue
                 ;;
             q)
                 echo "Bye"
                 exit 0
                 ;;
             *)
                 echo "Incorrect choice..."
                 sleep 1
                 ;;
         esac
         ;;
      5)
         clear
         draw_logo
         draw_opt_menu
         read -rp "Choice: " choice
         case $choice in
             1) opt_chaotic ;;
             2) opt_cachyos ;;
             3) opt_archgaming ;;
             4) opt_nsl ;;
             5) opt_fonts ;;
             6) opt_packages ;;
             7) opt_iptables ;;
             8) opt_wireguard ;;
             9) opt_fan-profile ;;
             b)
                 continue
                 ;;
             q)
                 echo "Bye"
                 exit 0
                 ;;
             *)
                 echo "Incorrect choice..."
                 sleep 1
                 ;;
         esac
         ;;
      6)
         clear
         draw_logo
         draw_settings_menu
         read -rp "Choice: " choice
         case $choice in
             1) set_reflector ;;
             2) show_env_vars ;;
             3) check_script_update ;;
             4) show_inst_pkg_official ;;
             5) show_inst_pkg_aur ;;
             b)
                 continue
                 ;;
             q)
                 echo "Bye"
                 exit 0
                 ;;
             *)
                 echo "Incorrect choice..."
                 sleep 1
                 ;;
         esac
         ;;
      7)
         clear
         draw_logo
         draw_credits_menu
         read -rp "Choice: " choice
         case $choice in
             b)
                 continue
                 ;;
             q)
                 echo "Bye"
                 exit 0
                 ;;
             *)
                 echo "Incorrect choice..."
                 sleep 1
                 ;;
         esac
         ;;
      q)
         echo "Bye"
         exit 0
         ;;
      *)
         echo "Incorrect choice..."
         sleep 1
         ;;
  esac
done
