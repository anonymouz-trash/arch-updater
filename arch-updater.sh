#!/usr/bin/bash

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
until [ "$CHOICE" = "q" ] ;
do
    clear
    cd ${app_pwd}
    echo -e "${magenta}+---<[ ${cyan}Arch Linux Updater Script ${magenta}]>--------------------------+${nocolor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[${blue} 1${cyan}] ${white}Update Arch Linux with yay                            ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 2${cyan}] ${white}Update Arch Linux with pacman                         ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 3${cyan}] ${white}Update Mirrorlist with reflector                      ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 4${cyan}] ${white}Update debtap database                                ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 5${cyan}] ${white}Clean Arch Linux                                      ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 6${cyan}] ${white}All of the above [reflector, yay, debtap, cleaning]   ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[${blue} 7${cyan}] ${white}>> Customization submenu                              ${magenta}|${noclor}";
    echo -e "${magenta}| ${cyan}[${blue} 8${cyan}] ${white}>> Optimizations & Tweaks submenu                     ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[${blue} 9${cyan}] ${white}Settings / Environment                                ${magenta}|${noclor}";
    echo -e "${magenta}|                                                            |${nocolor}";
    echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Credits                                               ${magenta}|${noclor}";
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
            until [ "$CHOICE" = "b" ];
            do
                clear
                cd ${app_pwd}
                echo -e "${magenta}+---<[ ${cyan}Arch Linux Updater Script ${magenta}]>--------------------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> GRUB:                                                   ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 1${cyan}] ${white}Arch Silence Theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 2${cyan}] ${white}Xenlism Arch Theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 3${cyan}] ${white}Republic of Gamers Theme                              ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Icons:                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 4${cyan}] ${white}Colloid icon theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 5${cyan}] ${white}Obsidian icon theme  (Updated Faenza icon theme)      ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 6${cyan}] ${white}Reversal icon theme  (Xiaomis MIUI lookalike)         ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 7${cyan}] ${white}WhiteSur icon theme  (macOS lookalike)                ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> GTK/KDE Designs:                                        ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 8${cyan}] ${white}Lavanda KDE/GTK theme                                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 9${cyan}] ${white}WhiteSur KDE/GTK theme                                ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Cursors:                                                ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Bibata cursor theme                                   ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Firefox:                                                ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}11${cyan}] ${white}WhiteSur theme                                        ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Terminal customization:                                 ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}12${cyan}] ${white}Install OhMyZsh!                                      ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}13${cyan}] ${white}Install fastfetch and copy minimal config             ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}14${cyan}] ${white}Install tmux and copy minimal config                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}q${cyan}] ${white}Quit                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        cust_simple-arch-grub-theme
                        ;;
                    2)
                        cust_xenlism-arch-grub-theme
                        ;;
                    3)
                        cust_rog-grub-theme
                        ;;
                    4)
                        cust_colloid
                        ;;
                    5)
                        cust_obsidian
                        ;;
                    6)
                        cust_reversal
                        ;;
                    7)
                        cust_whitesur_icon
                        ;;
                    8)
                        cust_lavanda
                        ;;
                    9)
                        cust_whitesur
                        ;;
                    10)
                        cust_bibata
                        ;;
                    11)
                        cust_firefox
                        ;;
                    12)
                        cust_ohmyzsh
                        ;;
                    13)
                        cust_fastfetch
                        ;;
                    14)
                        cust_tmux
                        ;;
                    b)
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
            ;;
        8)
            until [ "$CHOICE" = "b" ] ;
            do
                clear
                cd ${app_pwd}
                echo -e "${magenta}+---<[ ${cyan}Arch Linux Updater Script ${magenta}]>--------------------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Repositorys                                             ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 1${cyan}] ${white}Install/Remove Chaotic (precompiled AUR packages)     ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 2${cyan}] ${white}Install/Remove CachyOS (gaming optimized packages)    ${magenta}|${noclor}";
                echo -e "${magenta}| ${white}     Configuration: ${red}https://wiki.cachyos.org/${nocolor}              ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Additional packages                                     ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 3${cyan}] ${white}Install additional pacman / yay / cachyos packages    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 4${cyan}] ${white}Install additional Windows fonts                      ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Gaming                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 5${cyan}] ${white}Install AMD / NVIDIA / INTEL drivers with Vulkan      ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 6${cyan}] ${white}WINE dependencies & MangoHUD / gOverlay / vkBasalt    ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 7${cyan}] ${white}Install Gamemode- / Gamescope-Service (FSR)           ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Performance & Tweaks                                    ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue} 8${cyan}] ${white}Add Batocera Dual-Boot entry to GRUB                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue} 9${cyan}] ${white}Enable ClearType rendering                            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}10${cyan}] ${white}Improve I/O performance (for SSDs & NVMEs)            ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}11${cyan}] ${white}Improve device performance (for Laptops/Desktops)     ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Network-Sahres                                          ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}12${cyan}] ${white}Apply SMB-Shares to /etc/fstab                        ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}13${cyan}] ${white}Apply SFTP-Shares to /etc/fstab (not working)         ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}>> Useful scripts                                          ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[${blue}14${cyan}] ${white}Copy wireguard scripts to /usr/local/bin              ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[${blue}15${cyan}] ${white}Copy fan-profile script to /usr/local/bin             ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}q${cyan}] ${white}Quit                                                  ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                echo "";
                read -p "#> " CHOICE
                case $CHOICE in
                    1)
                        opt_chaotic
                        ;;
                    2)
                        opt_cachyos
                        ;;
                    3)
                        opt_packages
                        ;;
                    4)
                        opt_fonts
                        ;;
                    5)
                        opt_gpu_drivers
                        ;;
                    6)
                        opt_wine
                        ;;
                    7)
                        opt_gamemode
                        ;;
                    8)
                        opt_batocera
                        ;;
                    9)
                        opt_cleartype
                        ;;
                    10)
                        opt_io-performance
                        ;;
                    11)
                        opt_dev-performance
                        ;;
                    12)
                        opt_smbshares
                        ;;
                    13)
                        opt_sftpshares
                        ;;
                    14)
                        opt_wireguard-sh
                        ;;
                    15)
                        opt_fan-profile-sh
                        ;;
                    b)
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
            ;;
        9)
            until [ "$CHOICE" = "b" ];
            do
                clear
                echo -e "${magenta}+---<[ ${cyan}Arch Linux Updater Script ${magenta}]>--------------------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Settings:                                                  ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}reflector                                             ${magenta}|${noclor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Environment:                                               ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${nocolor}Script path = ${app_pwd}                                 ${magenta}|${nocolor}";
                echo -e "${magenta}| ${nocolor}User home   = ${app_home}                                ${magenta}|${nocolor}";
                echo -e "${magenta}| ${nocolor}Desktop     = ${de,,}                                    ${magenta}|${nocolor}";
                echo -e "${magenta}| ${nocolor}Shell       = $SHELL (if it's false, reboot)             ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}q${cyan}] ${white}Quit                                                  ${magenta}|${noclor}";
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
            ;;
        10)
            until [ "$CHOICE" = "b" ];
            do
                clear
                echo -e "${magenta}+---<[ ${cyan}Arch Linux Updater Script ${magenta}]>--------------------------+${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${white}Credits and big thanks to:                                 ${magenta}|${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${blue}Arch Silence GRUB Theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://www.pling.com/p/1111545                         ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}Xenlism Arch GRUB Theme                                    ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/xenlism/Grub-themes                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}ROG GRUB Theme                                             ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/thekarananand/ROG_GRUB_Theme         ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}Colloid Icon Theme                                         ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/vinceliuice/Colloid-icon-theme       ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}Obsidian Icon Theme                                        ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/madmaxms/iconpack-obsidian           ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}Reversal Icon Theme                                        ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/yeyushengfan258/Reversal-icon-theme  ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}GTK/KDE/Icon Themes                                        ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/vinceliuice                          ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}Bibata Cursor Theme                                        ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/ful1e5/Bibata_Cursor                 ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}My own Fastfetch Preset Fork from examples                 ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/fastfetch-cli/fastfetch              ${magenta}|${noclor}";
                echo -e "${magenta}| ${blue}OhMyZsh!                                                   ${magenta}|${noclor}";
                echo -e "${magenta}|    ${white}https://github.com/ohmyzsh/ohmyzsh                      ${magenta}|${noclor}";

                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}|                                                            |${nocolor}";
                echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                echo -e "${magenta}| ${cyan}[ ${blue}q${cyan}] ${white}Quit                                                  ${magenta}|${noclor}";
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
