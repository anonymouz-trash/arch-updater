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
version=2.9

### Menu section

until [ "$CHOICE" = "q" ] ;
do
    clear
    cd ${pwd}
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
            echo -e "\n${blue}#>${white} Update Mirrorlist with reflector${nocolor}\n"
            update_mirrorlist
            echo -e "\n${blue}#>${white} Update Arch Linux with yay${nocolor}\n"
            update_yay
            echo -e "\n${blue}#>${white} Update de debtap database${nocolor}\n"
            update_debtap
            echo -e "\n${blue}#>${white} Clean Arch Linux${nocolor}\n"
            clean_arch
            echo
                        ;;
        7)
            until [ "$CHOICE" = "b" ] ;
            do
                clear
                cd ${pwd}
                echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> GRUB:                                                   ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Simple Arch Linux Theme                               ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Icons:                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Colloid icon theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Obsidian icon theme                                   ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> GTK/KDE Designs:                                        ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Lavanda KDE/GTK theme                                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}MacSonoma KDE/GTK theme                               ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}6${cyan}] ${white}WhiteSur KDE/GTK theme                                ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Cursors:                                                ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}7${cyan}] ${white}Bibata cursor theme                                   ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Terminal customization:                                 ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}8${cyan}] ${white}Install OhMyZsh!                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}9${cyan}] ${white}Install fastfetch and copy minimal config             ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Install tmux and copy minimal config                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        cust_grub-theme
                        ;;
                    2)
                        cust_colloid
                        ;;
                    3)
                        cust_obsidian
                        ;;
                    4)
                        cust_lavanda
                        ;;
                    5)
                        cust_macsonoma
                        ;;
                    6)
                        cust_whitesur
                        ;;
                    7)
                        cust_bibata
                        ;;
                    8)
                        cust_ohmyzsh
                        ;;
                    9)
                        cust_fastfetch
                        ;;
                    10)
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
                cd ${pwd}
                echo -e "${magenta}+-------------<[ ${cyan}Arch Linux Upater Script ${white}$version ${magenta}]>-------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Repositorys                                             ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Install/Remove Chaotic AUR Repository                 ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Additional packages                                     ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Install additional pacman / yay packages              ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Install additional fonts, e.g. Windows fonts          ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Gaming                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Install AMD / NVIDIA / INTEL drivers with Vulkan      ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}WINE dependencies & MangoHUD / gOverlay / vkBasalt    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}6${cyan}] ${white}Install Gamemode- / Gamescope-Service (FSR)           ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Performance & Tweaks                                    ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}7${cyan}] ${white}Add Batocera Dual-Boot entry to GRUB                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}8${cyan}] ${white}Enable ClearType rendering                            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}9${cyan}] ${white}Improve I/O performance (for SSDs & NVMEs)            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Improve device performance (for Laptops/Desktops)     ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Network-Sahres                                          ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}11${cyan}] ${white}Apply SMB-Shares to /etc/fstab                        ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
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
                        opt_packages
                        ;;
                    3)
                        opt_fonts
                        ;;
                    4)
                        opt_gpu_drivers
                        ;;
                    5)
                        opt_wine
                        ;;
                    6)
                        opt_gamemode
                        ;;
                    7)
                        opt_batocera
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
            exit
            ;;
        *)
            echo
            echo -e "${magenta}Wrong input!${nocolor}"
            read -p "Press any key to resume ..."
            ;;
    esac
done
