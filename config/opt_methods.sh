#!/usr/bin/env bash

opt_chaotic(){
    clear
    echo -e "\n${white}[+] ${blue}Installing or updating Chaotic AUR repository...${nocolor}\n"
	sleep 2

    if [ "$(${pacman_cmd} -Qe chaotic-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            sudo ${pacman_cmd} -Rsnc chaotic-keyring chaotic-mirrorlist
            sudo sed -i "s/\[chaotic-aur\]//g" ${PACMAN_CONF}
            sudo sed -i "s/Include = ${PACMAN_DIR}\/chaotic-mirrorlist//g" ${PACMAN_CONF}
        fi
        sudo ${pacman_cmd} -Sy
        return
    else
        echo -e "${blue}Please copy the key after\n\n${magenta}pacman-key --recv-key${blue} or ${magenta}pacman-key --lsign-key\n\n${blue}on the next webpage and paste it in here.${nocolor}\n"
        read -p "Press any key to resume ..."
        xdg-open https://aur.chaotic.cx/docs
        read -p "Enter key: " key_keyserver
        sudo pacman-key --recv-key ${key_keyserver} --keyserver keyserver.ubuntu.com
		sudo pacman-key --lsign-key ${key_keyserver}
		sudo ${pacman_cmd} -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
		echo "[chaotic-aur]" | sudo tee -a ${PACMAN_CONF} > /dev/null
		echo "Include = ${PACMAN_DIR}/chaotic-mirrorlist" | sudo tee -a ${PACMAN_CONF} > /dev/null
		sudo ${pacman_cmd} -Sy
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_cachyos(){
    clear
    echo -e "\n${white}[+] ${blue}Installing or updating CachyOS repository...${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
    if [ "$(${pacman_cmd} -Qe cachyos-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            sudo ./cachyos-repo/cachyos-repo.sh --remove
        fi
    else
        curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
        tar xvf cachyos-repo.tar.xz
        sudo ./cachyos-repo/cachyos-repo.sh --install
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

opt_packages(){
    clear
    echo -e "\n${white}[+] ${blue}Installing additional packages...${nocolor}\n"
    sleep 2

    read -p 'Do you want to edit pacman package list before installing? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        nano ./assets/opt_pkglist-pacman
    fi
    sudo ${pacman_cmd} -S --needed - < <(grep -Ev '^[[:space:]]*(#|$)' ./assets/opt_pkglist-pacman)

    read -p 'Do you want to install additional yay packages? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        if [[ ${app_yay} == "0" ]]; then
            install_yay
        fi
        read -p 'Do you want to edit yay package list before installing? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            nano ./assets/opt_pkglist-yay
        fi
        yay -S --needed - < <(grep -Ev '^[[:space:]]*(#|$)' ./assets/opt_pkglist-yay)
    fi

    read -p 'Do you want to install additional CachyOS packages? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        read -p 'Do you want to edit CachyOS package list before installing? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            nano ./assets/opt_pkglist-cachyos
        fi
        sudo ${pacman_cmd} -S --needed - < <(grep -Ev '^[[:space:]]*(#|$)' ./assets/opt_pkglist-cachyos)
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_archgaming(){
    clear
    echo -e "\n${white}[+] ${blue}Launching archgaming script...${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
    if [ -d archgaming ]; then
        cd archgaming
        git pull
        sudo -E ./gaming.sh
    else
        git clone https://github.com/xi-Rick/archgaming.git
        cd archgaming
        sudo -E ./gaming.sh
    fi
    if ! ${pacman_cmd} -Q gamescope &> /dev/null ; then
        echo
        read -p "Do you want to install Valve's upscaler gamescope? [y/N] " input
        echo
        if [[ ${input} == "y" ]]; then
            sudo ${pacman_cmd} -S --needed gamescope
        fi
    fi
    echo
    echo "For some services like Battle.net it's important to have a correct '/etc/hosts'-file, so ..."
    echo "What's your local domain? E.g. for Fritz!Box users 'fritz.box' is common. "
    read -p "If you just press Enter 'localdomain' would be set: " input
    if [[ ${input} == "" ]]; then
        LOCALDOMAIN=localdomain
    else
        LOCALDOMAIN=${input}
    fi
    echo "[+] Write: 127.0.0.1  localhost       $(hostnamectl hostname).$LOCALDOMAIN $(hostnamectl hostname) >> /etc/hosts"
    if grep -q "127.0.0.1" "/etc/hosts"; then
        sudo sed -i "s/.*127.0.0.1.*/127.0.0.1  localhost       $(hostnamectl hostname).$LOCALDOMAIN $(hostnamectl hostname)/g" /etc/hosts
    else
        echo "127.0.0.1 localhost       $(hostnamectl hostname).${LOCALDOMAIN}  $(hostnamectl hostname)" | sudo tee -a /etc/hosts > /dev/null
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

opt_nsl(){
    clear
    echo -e "\n${white}[+] ${blue}Launch NonSteamLaunchers On Steam Deck...${nocolor}\n"
    echo -e "${white}Don't worry this also works on Desktops. ;-)${nocolor}"
    sleep 2
    cd ~/.cache/arch-updater
    if [ -d NonSteamLaunchers-On-Steam-Deck ]; then
        cd NonSteamLaunchers-On-Steam-Deck
        git pull
        ./NonSteamLaunchers.sh
    else
        git clone https://github.com/moraroy/NonSteamLaunchers-On-Steam-Deck.git
        cd NonSteamLaunchers-On-Steam-Deck
        ./NonSteamLaunchers.sh
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

opt_fonts(){
    clear
    echo -e "\n${white}[+] ${blue}Installing additional Windows fonts...${nocolor}\n"
	sleep 2
    if [[ ${app_yay} == "0" ]]; then
            install_yay
    fi
    yay -S --needed ttf-ms-win10-auto
    yay -S --needed ttf-ms-win11-auto
    echo
    read -p "Press any key to resume ..."
}

opt_wireguard(){
    clear
    echo -e "\n${white}[+] ${blue}Copy wireguard activate/deactivate script in /usr/local/sbin/wireguard-vpn${nocolor}\n"
    echo -e "${white}    Don't forget to put your wireguard profile in /etc/wireguard as wg0.conf${nocolor}\n"
	sleep 2
    if [ -f /usr/local/sbin/wireguard-vpn ]; then
        read -p 'Wireguard scripts already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /usr/local/sbin/wireguard-vpn
            sudo rm -v /etc/NetworkManager/conf.d/dns.conf
            sudo systemctl disable --now systemd-resolved.service
            sudo ${pacman_cmd} -Rsnc systemd-resolvconf wireguard-tools
        fi
    else
        if ! ${pacman_cmd} -Qi systemd-resolvconf wireguard-tools &> /dev/null ; then
            sudo ${pacman_cmd} -S systemd-resolvconf wireguard-tools
        fi
        sudo cp ./assets/opt_wireguard-vpn.sh /usr/local/sbin/wireguard-vpn
        sudo cp ./assets/opt_wireguard-dns.conf /etc/NetworkManager/conf.d/dns.conf
    fi
    echo
    echo -e "\n${white}[+] ${blue}Reboot your system to let ${white}systemd-resolved & NetworkManager${blue} load properly${nocolor}\n"
    read -p "Press any key to resume ..."
}

opt_fan-profile(){
    clear
    echo -e "\n${white}[+] ${blue}Add show-fan-profile script in /usr/local/bin...${nocolor}\n"
	sleep 2
    if [ -f /usr/local/bin/show-fan-profile ]; then
        read -p 'Show-fan-profile script already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /usr/local/bin/show-fan-profile
        fi
    else
        sudo cp ./assets/opt_show-fan-profile.sh /usr/local/bin/show-fan-profile
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_iptables(){
    clear
    echo -e "\n${white}[+] ${blue}Add preconfigured iptables ruleset script to /etc/iptables...${nocolor}\n"
    sleep 2
    if grep -qx "# Do not delete this file or edit this first comment! It is from arch-updater!" /etc/iptables/iptables.rules ; then
        read -p 'Iptables ruleset already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo systemctl disable --now iptables.service
            sudo rm -v /etc/iptables/iptables.rules
            sudo touch /etc/iptables/iptables.rules
            if ${pacman_cmd} -Q iptables-nft &> /dev/null ; then
                read -p 'Do you also want iptables itself to be removed? [y/N] ' input
                if [[ ${input} == "y" ]]; then
                    sudo ${pacman_cmd} -Rsnc iptables-nft
                fi
            fi
        fi
    else
        if ! ${pacman_cmd} -Q iptables-nft &> /dev/null ; then
            sudo ${pacman_cmd} -S iptables-nft
        fi
        sudo systemctl disable --now iptables.service
        read -p 'Do you want to edit iptables rulelist before installing? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            nano ./assets/opt_iptables.rules
        fi
        sudo cp -v ./assets/opt_iptables.rules /etc/iptables/iptables.rules
        sudo systemctl enable --now iptables.service
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_sd_pacman_normal(){
    clear
    echo -e "\n${white}[+] ${blue}Enabling pacman ${purple}system-wide normally${blue}...${nocolor}\n"
    sleep 2
    sudo steamos-readonly disable
    if [ -d ${PACMAN_DIR}/gnupg ]; then
        sudo rm -rfv ${PACMAN_DIR}/gnupg
    fi
    sudo pacman-key --init
    sudo pacman-key --populate archlinux
    sudo pacman-key --populate holo
    sudo ${pacman_cmd} -Syu
    #sudo steamos-readonly enable
    echo
    read -p "Press any key to resume ..."
}

opt_sd_pacman_userspace(){
    clear
    echo -e "\n${white}[+] ${blue}Enabling pacman in ${purple}userspace${blue}...${nocolor}\n"
    sleep 2
    sudo ./assets/opt_sd_pacman_userspace.sh
    echo
    read -p "Press any key to resume ..."
}
