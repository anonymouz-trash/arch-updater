#!/usr/bin/bash

opt_chaotic(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Chaotic AUR repository...${nocolor}\n"
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
}

opt_graphic_drivers(){
    clear
    echo -e "\n${white}#> ${blue}Installing AMD/Nvidia GPU drivers...${nocolor}\n"
	sleep 2
    read -p 'AMD or Nvidia? Just press [Enter] to skip. [a/n] ' input
    if [[ ${input} == "n" ]]; then
		sudo pacman -S --needed nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia libvdpau libxnvctrl vulkan-icd-loader lib32-vulkan-icd-loader envycontrol nvtop
    elif [[ ${input} == "a" ]]; then
		sudo pacman -S --needed mesa lib32-mesa mesa-vdpau lib32-mesa-vdpau lib32-vulkan-radeon vulkan-radeon glu lib32-glu vulkan-icd-loader lib32-vulkan-icd-loader
    fi
}

opt_packages(){
    clear
    echo -e "\n${white}#> ${blue}Installing additional packages...${nocolor}\n"
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
}

opt_wine(){
    clear
    echo -e "\n${white}#> ${blue}Get out of WINE dependency hell...${nocolor}\n"
	sleep 2
    sudo pacman -S --needed wine-staging
    sudo pacman -S --needed giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
    read -p 'Do you want to install also vkBasalt, MangoHUD & gOverlay? [y/N] ' input
    if [[ ${input} == "y" ]]; then
        check_4_yay
        yay -S --needed vkbasalt mangohud goverlay
    fi
}

opt_batocera(){
    clear
    echo -e "\n${white}#> ${blue}Make Batocera Dual-Bootable...${nocolor}\n"
	sleep 2
    if [ -f /etc/grub.d/15_batocera ]; then
        read -p 'Boot entry already exists! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            sudo rm -v /etc/grub.d/15_batocera
        fi
    else
        sudo cp -v ./assets/opt_15_batocera /etc/grub.d/15_batocera
        echo -e "${magenta}Copied! ${blue}Now running grub-mkconfig.${nocolor}"
        echo -e "${blue}If Batocera EFI boot partition is installed anywhere it will find it.${nocolor}"
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
}

opt_gamemode(){
    clear
    echo -e "\n${white}#> ${blue}Installing gamemode/gamescope service...${nocolor}\n"
	sleep 2
    check_4_yay
    if [ "$(yay -Qe gamemode | wc -l)" -ge 1 ]; then
        read -p 'Gamemode already installed! Do you want to remove it? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            yay -Rsnc gamemode gamescope
        fi
        return
    else
        yay -S gamemode gamescope
        systemctl --user enable gamemoded.service --now
    fi
}

opt_fonts(){
    clear
    echo -e "\n${white}#> ${blue}Installing additional fonts...${nocolor}\n"
	sleep 2
    check_4_yay
    yay -S --needed noto-fonts-git ttf-dejavu ttf-liberation ttf-opensans terminus-font ttf-ubuntu-font-family ttf-ms-win11 ttf-ms-win10
}

opt_cleartype(){
    clear
    echo -e "\n${white}#> ${blue}Installing ClearType rendering...${nocolor}\n"
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
}

opt_io-performance(){
    clear
    echo -e "\n${white}#> ${blue}Configure I/O performance...${nocolor}\n"
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
}

opt_dev-performance(){
    clear
    echo -e "\n${white}#> ${blue}Configure device performance...${nocolor}\n"
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
}

opt_smbshares(){
    clear
    echo -e "\n${white}#> ${blue}Add SMB-Shares...${nocolor}\n"
	sleep 2
    if grep -Fxq "#SMB-Shares" /etc/fstab; then
        read -p "#SMB-Shares comment found! Do you want to edit fstab? [y/N] " input
		if [[ ${input} == "y" ]]; then
            sudo nano /etc/fstab
        fi
    else
			echo "You have to change/check the credentials and mount paths!"
			echo "Just search the given variables with [Ctrl-\] in nano and replace them."
			read -p
            sudo nano ./assets/opt_nas-smb-acc.txt
			sudo nano ./assets/opt_nas-smb-mount.txt
			cat ./assets/opt_nas-smb-mount.txt | sudo tee -a /etc/fstab > /dev/null
			cp ./assets/opt_nas-smb-acc.txt ~/.smb
			chmod 600 ~/.smb
			sudo systemctl daemon-reload
    fi
}

opt_zsh(){
    clear
    echo -e "\n${white}#>  ${blue}Make Z shell standard for ${white}${USER}${blue} and root...${nocolor}\n"
	sleep 2
    if [ "$(pacman -Qe zsh | wc -l)" -ge 1 ]; then
		echo ">> Change standard shell to ZSH for logged in user"
		chsh -s $(which zsh) ${USER}
		echo ">> Change standard shell to ZSH for root"
		sudo chsh -s $(which zsh)
		echo "Install Oh My ZSH! for logged in user"
		sleep 1
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		echo "Install Oh My ZSH! for root"
		sleep 1
		sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		sed -i 's/robbyrussell/refined/g' ~/.zshrc
		sudo sed -i 's/robbyrussell/fox/g' /root/.zshrc
    fi
}
