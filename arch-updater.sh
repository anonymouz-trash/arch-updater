#!/usr/bin/bash

# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${pwd}

### Include required functions
source ./config/colors.sh
source ./config/app_methods.sh
source ./config/cust_methods.sh
source ./config/opt_methods.sh

### Declare environment variables

# script version in title
version=2.5

### Menu section

until [ "$CHOICE" = "q" ] ;
do
    clear
    echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Update Arch Linux with yay                            ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Update Arch Linux with pacman                         ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Update Mirrorlist with reflector                      ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Update debtap database                                ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}Clean Arch Linux                                      ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}6${cyan}] ${white}All of the above [reflector, yay, debtap, cleaning]   ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[ ${blue}7${cyan}] ${white}>> Customization submenu                              ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[ ${blue}8${cyan}] ${white}>> Optimizations & Tweaks submenu                     ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[ ${blue}9${cyan}] ${white}Settings                                              ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[ ${blue}q${cyan}] ${white}Quit the script                                       ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
    echo "";
    read -p "#> " CHOICE
    case $CHOICE in
        1)
    	    update_yay
            ;;
        2)
            update_pacman
      	    ;;
        3)
       	    update_mirrorlist
       	    ;;
        4)
            update_debtap
            ;;
        5)
            clean_arch
            ;;
        6)
            update_mirrorlist
            update_yay
            update_debtap
            clean_arch
            ;;
        7)
            until [ "$CHOICE" = "b" ] ;
            do
                clear
                echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Customization:                                             ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Conky-Colors                                          ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Conky Clock with Weather                              ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Arch Linux GRUB theme                                 ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Colloid icon theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}Obsidian icon theme                                   ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}6${cyan}] ${white}Lavanda KDE/GTK theme                                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}7${cyan}] ${white}MacSonoma KDE/GTK theme                               ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}8${cyan}] ${white}WhiteSur KDE/GTK theme                                ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}9${cyan}] ${white}Bibata cursor theme                                   ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Install fastfetch and copy minimal config             ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}11${cyan}] ${white}Install tmux and copy minimal config                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        cust_conky-colors
                        ;;
                    2)
                        cust_conky-clock-weather
                        ;;
                    3)
                        cust_grub-theme
                        ;;
                    4)
                        cust_colloid
                        ;;
                    5)
                        cust_obsidian
                        ;;
                    6)
                        cust_lavanda
                        ;;
                    7)
                        cust_macsonoma
                        ;;
                    8)
                        cust_whitesur
                        ;;
                    9)
                        cust_bibata
                        ;;
                    10)
                        cust_fastfetch
                        ;;
                    11)
                        cust_tmux
                        ;;
                    b)
                        ;;
                    *)
                        echo
                        echo -e "${magenta}Wrong input!${nocolor}"
                        read -p "Press any key to resume ..."
                        ;;
                esac
            done
            ;;
        8)
            until [ "$CHOICE" = "b" ] ;
            do
                clear
                echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Optimizations & Tweaks:                                    ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Install/Remove Chaotic AUR Repository                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Install AMD / Nvidia drivers                          ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Install additional pacman / yay packages              ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Get out of Wine dependency hell                       ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}Add Batocera Dual-Boot entry to GRUB                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}6${cyan}] ${white}Install Gamemode- / Gamescope-Service (FSR)           ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}7${cyan}] ${white}Install additional fonts, e.g. Windows fonts          ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}8${cyan}] ${white}Enable ClearType rendering                            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}9${cyan}] ${white}Improve I/O performance (for SSDs & NVMEs)            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Improve device performance (for Laptops/Desktops)     ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}11${cyan}] ${white}Make Z shell default and install Oh My ZSH            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}12${cyan}] ${white}Apply SMB-Shares to /etc/fstab                        ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}13${cyan}] ${white}Apply all options from above                          ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        opt_chaotic
                        ;;
                    2)
                        opt_graphic_drivers
                        ;;
                    3)
                        opt_packages
                        ;;
                    4)
                        opt_wine
                        ;;
                    5)
                        opt_batocera
                        ;;
                    6)
                        opt_gamemode
                        ;;
                    7)
                        opt_fonts
                        ;;
                    8)
                        opt_cleartype
                        ;;
                    9)
                        opt_io-performance
                        ;;
                    10)
                        opt_dev-performance
                        ;;
                    11)
                        opt_zsh
                        ;;
                    12)
                        opt_smbshares
                        ;;
                    13)
                        echo -e "${blue}Install Chaotic AUR Repository${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_chaotic
                        echo -e "${blue}Install AMD / Nvidia drivers${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_graphic_drivers
                        echo -e "${blue}Install additional pacman / yay packages${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_packages
                        echo -e "${blue}Get out of Wine dependency hell${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_wine
                        echo -e "${blue}Add Batocera Dual-Boot to system${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_batocera
                        echo -e "${blue}Install Gamemode- / Gamescope-Service (FSR)${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_gamemode
                        echo -e "${blue}Install additional fonts, e.g. Windows fonts${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_fonts
                        echo -e "${blue}Enable ClearType rendering${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_cleartype
                        echo -e "${blue}Improve I/O performance (for SSDs & NVMEs)${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_io-performance
                        echo -e "${blue}Improve device performance (for Laptops/Desktops)${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_dev-performance
                        echo -e "${blue}Make Z shell default and install Oh My ZSH${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_zsh
                        echo -e "${blue}Apply SMB-Shares to /etc/fstab${nocolor}"
                        read -p "Press any key to resume ..."
                        opt_smbshares
                        ;;
                    b)
                        ;;
                    *)
                        echo
                        echo -e "${magenta}Wrong input!${nocolor}"
                        read -p "Press any key to resume ..."
                        ;;
                esac
            done
            ;;
        9)
            until [ "$CHOICE" = "b" ] ;
            do
                clear
                echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Settings:                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}reflector                                             ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        set_reflector
                        ;;
                    b)
                        ;;
                    *)
                        echo
                        echo -e "${magenta}Wrong input!${nocolor}"
                        read -p "Press any key to resume ..."
                        ;;
                esac
            done
            ;;
        q)
            echo
            echo -e "${magenta}Script ${blue}terminated, Good bye..."
            ;;
        *)
            echo
            echo -e "${magenta}Wrong input!${nocolor}"
            read -p "Press any key to resume ..."
            ;;
    esac
done
