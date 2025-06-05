#!/usr/bin/bash

opt_chaotic(){
    clear
    echo -e "\n${white}[+] ${blue}Installing or updating Chaotic AUR repository...${nocolor}\n"
	sleep 2

    if [ "$(pacman -Qe chaotic-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            sudo pacman -Rsnc chaotic-keyring chaotic-mirrorlist
            sudo sed -i 's/\[chaotic-aur\]//g' /etc/pacman.conf
            sudo sed -i 's/Include = \/etc\/pacman\.d\/chaotic-mirrorlist//g' /etc/pacman.conf
        fi
        sudo pacman -Sy
        return
    else
        echo -e "${blue}Please copy the key after\n\n${magenta}pacman-key --recv-key${blue} or ${magenta}pacman-key --lsign-key\n\n${blue}on the next webpage and paste it in here.${nocolor}\n"
        read -p "Press any key to resume ..."
        xdg-open https://aur.chaotic.cx/docs
        read -p "Enter key: " key_keyserver
        sudo pacman-key --recv-key ${key_keyserver} --keyserver keyserver.ubuntu.com
		sudo pacman-key --lsign-key ${key_keyserver}
		sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
		echo '[chaotic-aur]' | sudo tee -a /etc/pacman.conf > /dev/null
		echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf > /dev/null
		sudo pacman -Sy
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_cachyos(){
    clear
    echo -e "\n${white}[+] ${blue}Installing or updating CachyOS repository...${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
    if [ "$(pacman -Qe cachyos-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
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
        nano ./assets/opt_pkglist-pacman.txt
    fi
    sudo pacman -S --needed - < ./assets/opt_pkglist-pacman.txt

    read -p 'Do you want to install additional yay packages? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        check_4_yay
        read -p 'Do you want to edit yay package list before installing? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            nano ./assets/opt_pkglist-yay.txt
        fi
        yay -S --needed - < ./assets/opt_pkglist-yay.txt
    fi

    read -p 'Do you want to install additional CachyOS packages? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        read -p 'Do you want to edit CachyOS package list before installing? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            nano ./assets/opt_pkglist-cachyos.txt
        fi
        sudo pacman -S --needed - < ./assets/opt_pkglist-cachyos.txt
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
        sudo ./gaming.sh
    else
        git clone https://github.com/anonymouz-trash/archgaming.git
        cd archgaming
        sudo ./gaming.sh
    fi
    if ! pacman -Q gamescope &> /dev/null ; then
        echo
        read -p "Do you want to install Valve's upscaler gamescope? [y/N] " input
        echo
        if [[ ${input} == "y" ]]; then
            sudo pacman -S --needed gamescope
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
        git clone https://github.com/anonymouz-trash/NonSteamLaunchers-On-Steam-Deck.git
        cd NonSteamLaunchers-On-Steam-Deck
        ./NonSteamLaunchers.sh
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

opt_batocera(){
    clear
    echo -e "\n${white}[+] ${blue}Make Batocera Dual-Bootable...${nocolor}\n"
	sleep 2
    if [ -f /etc/grub.d/15_batocera ]; then
        read -p 'Boot entry already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /etc/grub.d/15_batocera
        fi
    else
        sudo cp -v ./assets/opt_15_batocera /etc/grub.d/15_batocera
        sudo chmod 0755 /etc/grub.d/15_batocera
        if ! [ "$(pacman -Qe os-prober | wc -l)" -ge 1 ]; then
            sudo pacman -S os-prober
            sudo sed -i 's/#GRUB_DISABLE_OS_PROBER/GRUB_DISABLE_OS_PROBER/g' /etc/default/grub
        fi
        echo -e "${magenta}Copied! ${blue}Now running grub-mkconfig.${nocolor}"
        echo -e "${blue}If Batocera EFI boot partition is installed anywhere it will find it.${nocolor}"
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_fonts(){
    clear
    echo -e "\n${white}[+] ${blue}Installing additional Windows fonts...${nocolor}\n"
	sleep 2
    check_4_yay
    yay -S --needed ttf-ms-win10-auto
    yay -S --needed ttf-ms-win11-auto
    echo
    read -p "Press any key to resume ..."
}

opt_cleartype(){
    clear
    echo -e "\n${white}[+] ${blue}Installing ClearType rendering...${nocolor}\n"
	sleep 2
    check_4_yay
    if [ "$(yay -Qe freetype2 | wc -l)" -ge 1 ]; then
        read -p 'ClearType Rendering already enabled! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm /etc/fonts/conf.d/70-no-bitmaps.conf
            sudo rm /etc/fonts/conf.d/10-sub-pixel-rgb.conf
            sudo rm /etc/fonts/conf.d/11-lcdfilter-default.conf
            sudo sed -i 's/export/#export/g' /etc/profile.d/freetype2.sh
            yay -Rsnc freetype2
        fi
        return
    else
        yay -S --needed freetype2
        sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
        sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
        sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
        sudo sed -i 's/#export/export/g' /etc/profile.d/freetype2.sh
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_io-performance(){
    clear
    echo -e "\n${white}[+] ${blue}Configure I/O performance...${nocolor}\n"
	sleep 2
    if [ -f /etc/udev/rules.d/60-ioschedulers.rules ]; then
        read -p 'I/O performance rule already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /etc/udev/rules.d/60-ioschedulers.rules
            sudo systemctl disable fstrim.timer --now
        fi
    else
        sudo cp ./assets/opt_60-ioschedulers.rules /etc/udev/rules.d/60-ioschedulers.rules
        sudo systemctl enable fstrim.timer --now
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_dev-performance(){
    clear
    echo -e "\n${white}[+] ${blue}Configure device performance...${nocolor}\n"
	sleep 2
    if [ "$(pacman -Qe tuned | wc -l)" -ge 1 ]; then
        read -p 'Device performance settings are applied! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo systemctl disable tuned.service --now
            sudo systemctl disable tlp.service --now
            sudo pacman -Rsnc tlp tlp-rdw powertop tuned
        fi
    else
        sudo journalctl --vacuum-size=100M
        sudo journalctl --vacuum-time=2weeks
        read -p "Laptop or desktop? Just press [Enter] to skip. [l/d]" input
        sudo pacman -S tlp tlp-rdw powertop tuned
        sudo powertop --auto-tune
        sudo systemctl enable tuned.service --now
        sudo systemctl enable tlp.service --now
        if [[ ${input} == 'l' ]]; then
            sudo tuned-adm profile laptop-ac-powersave
        elif [[ ${input} == 'd' ]]; then
            sudo tuned-adm profile desktop
        fi
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_smbshares(){
    clear
    echo -e "\n${white}[+] ${blue}Add SMB-Shares...${nocolor}\n"
	sleep 2
    if grep -Fxq "#SMB-Shares" /etc/fstab; then
        read -p "#SMB-Shares comment found! Do you want to edit fstab? [y/N] " input
	    if [[ ${input} == "y" ]]; then
            sudo nano /etc/fstab
        fi
    else
	    echo "You have to change/check the credentials and mount paths!"
	    echo "Just search the given variables with [Ctrl-\] in nano and replace them."
        echo
        read -p "What's your SMB-Share username: " smb_user
	    read -p "What's the password: " smb_pass
	    sudo nano ./assets/opt_nas-smb-mount.txt
	    echo "username=${smb_user}" >> ~/.smb
	    echo "password=${smb_pass}" >> ~/.smb
	    cat ./assets/opt_nas-smb-mount.txt | sudo tee -a /etc/fstab > /dev/null
	    chmod 600 ~/.smb
	    mkdir -p ~/NAS/{backups,media,isoz,drive,shared}
	    sudo systemctl daemon-reload
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_sftpshares(){
    clear
    echo -e "\n${white}[+] ${blue}Add SFTP-Shares...${nocolor}\n"
	sleep 2
    if grep -Fxq "#SFTP-Shares" /etc/fstab; then
        read -p "#SFTP-Shares comment found! Do you want to edit fstab? [y/N] " input
	    if [[ ${input} == "y" ]]; then
            sudo nano /etc/fstab
        fi
    else
	    echo "You have to change/check the credentials, keys path and mount paths!"
	    echo "Just search the given variables and replace them."
        sleep 3
        nano ./assets/opt_nas-sftp-mount.txt
	    echo
        cat ./assets/opt_nas-sftp-mount.txt | sudo tee -a /etc/fstab > /dev/null
	    mkdir -p ~/NAS/{backups,media,isoz,drive,shared}
	    sudo systemctl daemon-reload
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_wireguard-sh(){
    clear
    echo -e "\n${white}[+] Add wireguard activate/deactivate script in /usr/local/bin...${nocolor}\n"
    echo -e "\n${white}   Don't forget to put your wireguard profile in /etc/wireguard/wg0.conf${nocolor}\n"
	sleep 2
    if [ -f /usr/local/bin/wireguard-vpn ]; then
        read -p 'Wireguard scripts already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /usr/local/bin/wireguard-vpn
        fi
    else
        if [ "$(pacman -Qe openresolv | wc -l > /dev/null)" -eq 0 ] || [ "$(pacman -Qe wireguard-tools | wc -l > /dev/null)" -eq 0 ]; then
            sudo pacman -S openresolv wireguard-tools
        fi
        sudo cp ./assets/opt_wireguard-vpn.sh /usr/local/bin/wireguard-vpn
    fi
    echo
    read -p "Press any key to resume ..."
}

opt_fan-profile-sh(){
    clear
    echo -e "\n${white}[+] Add show-fan-profile script in /usr/local/bin...${nocolor}\n"
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
