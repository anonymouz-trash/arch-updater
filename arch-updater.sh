#!/bin/bash

### requirements
# Very nice, credits: https://unix.stackexchange.com/a/433816

sed_escape() {
  sed -e 's/[]\/$*.^[]/\\&/g'
}

cfg_write() { # path, key, value
  cfg_delete "$1" "$2"
  echo "$2=$3" >> "$1"
}

cfg_read() { # path, key -> value
  test -f "$1" && grep "^$(echo "$2" | sed_escape)=" "$1" | sed "s/^$(echo "$2" | sed_escape)=//" | tail -1
}

cfg_delete() { # path, key
  test -f "$1" && sed -i "/^$(echo $2 | sed_escape).*$/d" "$1"
}

cfg_haskey() { # path, key
  test -f "$1" && grep "^$(echo "$2" | sed_escape)=" "$1" > /dev/null
}


### Declare environment variables

# script version in title
version=2.2

# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd

# reflector settings
country=$(cfg_read $pwd/assets/arch_updater.conf country)
fastest=$(cfg_read $pwd/assets/arch_updater.conf fastest)
protocol=$(cfg_read $pwd/assets/arch_updater.conf protocol)
score=$(cfg_read $pwd/assets/arch_updater.conf score)

# colors section
blue='\033[1;34m'
cyan='\033[1;36m'
magenta='\033[1;35m'
white='\033[1;37m'
nocolor='\033[0m'

### methods section

check_4_yay(){
    if ! command -v yay &> /dev/null ; then
        echo -e "\n${white}#> ${blue}Yay is not installed, installing...${nocolor}\n"
        sudo pacman -S build-essential git
        git clone https://aur.archlinux.org/yay.git
        cd yay
        sudo makepg -si
        cd ..
        rm -rf yay
    fi
}

update_yay(){
    clear
    echo -e "\n${white}#> ${blue}Updating Arch Linux with yay... ${nocolor}\n"
    sleep 2
	check_4_yay
    yay -Syyu
}

update_pacman(){
	clear
	echo -e "\n${white}#> ${blue}Updating Arch Linux with pacman... ${nocolor}\n"
	sleep 2
	sudo pacman -Syyu
}

update_mirrorlist(){
	clear
	echo -e "\n${white}#> ${blue}Updating Arch Linux mirrorlist with reflector... ${nocolor}\n"
	sleep 2
	if ! command -v reflector &> /dev/null ; then
		sudo pacman -S reflector
		sudo systemctl enable reflector.timer --now
	fi
	sudo reflector -c $country -f $fastest -p $protocol --score $score --save /etc/pacman.d/mirrorlist --verbose
}

clean_arch(){
    clear
	echo -e "\n${white}#> ${blue}Cleaning Arch Linux...${nocolor}\n"
	sleep 2
    check_4_yay
	echo -e "${cyan} Size of current user's cache: ${nocolor}\n"
	du -sh ~/.cache

	echo -e "${cyan} Size of pacman cache: ${nocolor}\n"
	du -sh /var/cache/pacman/pkg

	if [[ $yay == 1 ]]; then
		read -p 'Do you want to clear all (y) cached packages or just the ones that are not installed (N)? [y/N] ' input
		if [[ $input == "y" ]]; then
			yay -Scc
		else
			yay -Sc
		fi
		echo -e "\n${cyan} This is a list of packages not used by anyone... ${nocolor}\n"
		yay -Qtdq
		read -p 'Do you want to remove these packages? [y/N] ' input
		if [[ $input == "y" ]]; then
			yay -Rns $(yay -Qtdq)
		fi
	fi

    read -p 'Do you want to delete the contents of ~/.cache directory? [y/N] ' input
    if [[ $input == "y" ]]; then
		rm -rfv ~/.cache/*
	else
        read -p 'Do you want to delete the contents of ~/.cache/yay directory? [y/N] ' input
        if [[ $input == "y" ]]; then
            rm -rfv ~/.cache/yay/*
        fi
	fi

	clear

	echo -e "${cyan} Size of current User's cache: ${nocolor}\n"
	du -sh ~/.cache

	echo -e "${cyan} Size of pacman cache: ${nocolor}\n"
	du -sh /var/cache/pacman/pkg
}

update_debtap(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating debtap...${nocolor}\n"
	sleep 2
    check_4_yay
	if ! command -v debtap &> /dev/null ; then
		yay -S debtap
	fi
	sudo debtap -u
}

cust_conky-colors(){
	clear
	echo -e "\n${white}#> ${blue}Installing or updating Conky Colors...${nocolor}\n"
	sleep 2
	check_4_yay
	read -p "Do you want to (e)dit the conky-colors script before installing or (r)remove it? [e/r/N] " input
	if [[ $input == "e" ]]; then
		nano ./assets/conky-colors.sh
    elif [[ $input == "r" ]]; then
        if command -v  conky-colors &> /dev/null ; then
            yay -Rsnc conky-colors-git
            rm -rfv ~/.conky-colors
            return
        fi
	fi
	bash ./assets/conky-colors.sh
}

cust_conky-clock-weather(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Conky Clock with weather...${nocolor}\n"
	sleep 2
	if [ -d "/home/$USER/.conky/Clock-With-Weather-Conky" ]; then
        read -p "Do you want to (r)emove Conky clock with weather? [y/N] " input
        if [[ $input == "y" ]]; then
            killall conky
            rm -rfv ~/.conky
            return
        fi
		bash ~/.conky/Clock-With-Weather-Conky/scripts/setup.sh
	else
		if ! command -v wget &> /dev/null; then
            sudo pacman -S wget
        fi
		bash -c "$(wget --no-check-certificate --no-cache --no-cookies -O- https://raw.githubusercontent.com/takattila/Clock-With-Weather-Conky/v1.0.0/scripts/install.sh)"
	fi
}

cust_grub-theme(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating GRUB theme...${nocolor}\n"
	sleep 2
    sudo sed -i '/GRUB_DEFAULT=/c\GRUB_DEFAULT=saved' /etc/default/grub
    sudo sed -i '/GRUB_SAVEDEFAULT=/c\GRUB_SAVEDEFAULT=true' /etc/default/grub
    read -p 'Do you want the blue or red Arch Linux GRUB theme? [b/r] ' input
    if [[ $input == "b" ]]; then
      	sudo cp -rv ./assets/arch-silence_black-blue /boot/grub/themes
      	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-blue/theme.txt"' /etc/default/grub
    elif [[ $input == "r" ]];then
      	sudo cp -rv ./assets/arch-silence_black-red /boot/grub/themes
       	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-red/theme.txt"' /etc/default/grub
    fi
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

cust_colloid(){
    echo -e "\n${white}#> ${blue}Installing or updating Colloid icon theme...${nocolor}\n"
	sleep 2
    cd assets
    if [ -d "Colloid-icon-theme" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ $input == "r" ]]; then
            rm -rfv ./Colloid-icon-theme
            sudo rm -rfv /usr/share/icons/Colloid*
            return
        else
            cd Colloid-icon-theme
            git pull
            cd ..
        fi
    else
        git clone https://github.com/vinceliuice/Colloid-icon-theme.git
    fi
    sudo ./Colloid-icon-theme/install.sh -d /usr/share/icons -s all -t all
    if [[ -d Colloid-icon-theme ]] ; then
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ $input == "y" ]]; then
            rm -rfv ./Colloid-icon-theme
        fi
    fi
    cd ..
}

cust_obsidian(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Obsidian icon theme...${nocolor}\n"
	sleep 2
    cd assets
    if [ -d "iconpack-obsidian" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ $input == "r" ]]; then
            rm -rfv ./iconpack-obsidian
            sudo rm -rfv /usr/share/icons/Obsidian*
            return
        else
            cd iconpack-obsidian
            git pull
            cd ..
        fi
    else
        git clone https://github.com/madmaxms/iconpack-obsidian.git
    fi
    sudo cp -rv ./iconpack-obsidian/Obsidian* /usr/share/icons
    if [[ -d iconpack-obsidian ]] ; then
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ $input == "y" ]]; then
            rm -rfv ./iconpack-obsidian
        fi
    fi
    cd ..
}

cust_lavanda(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Lavanda GTK/KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the Lavanda script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/cust_lavanda.sh
	fi
	bash ./assets/cust_lavanda.sh
}

cust_macsonoma(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating MacSonoma KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the MacSonoma script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/cust_macsonoma.sh
	fi
	bash ./assets/cust_macsonoma.sh
}

cust_whitesur(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating WhiteSur GTK/KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the WhiteSur script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/cust_whitesur.sh
	fi
	bash ./assets/cust_whitesur.sh
}

cust_bibata(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Bibata cursor theme...${nocolor}\n"
	sleep 2
	check_4_yay
    if [ "$(yay -Qe bibata-cursor-theme | wc -l)" -ge 1 ]; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ $input == "r" ]]; then
            yay -Rsnc bibata-cursor-theme
            return
        fi
    else
        yay -S bibata-cursor-theme
    fi

}

cust_fastfetch(){
    clear
    echo -e "\n${white}#> ${blue}Installing or fastfetch...${nocolor}\n"
	sleep 2
	if [ "$(pacman -Qe bash | wc -l)" -ge 1 ] | [ "$(pacman -Qe bash | wc -l)" -ge 1 ] ; then
        echo -e "\n${white}#> ${cyan}Neither BASH or ZSH are installed, aborting...${nocolor}\n"
        sleep 2
    else
        if [ "$(pacman -Qe fastfetch | wc -l)" -ge 1 ]; then
            read -p "Already installed! Do you want to (r)emove it? [r/N] " input
            if [[ $input == "r" ]]; then
                sudo pacman -Rsnc fastfetch
                rm -rf ~/.config/fastfetch
                if [[ ${SHELL,,} =~ "zsh" ]]; then
                    grep -v 'echo ""'  ~/.zshrc > ~/.tmp_user_zshrc
                    sudo mv ~/.tmp_user_zshrc  ~/.zshrc
                    grep -v "myarch.jsonc"  ~/.zshrc > ~/.tmp_user_zshrc
                    sudo mv ~/.tmp_user_zshrc  ~/.zshrc

                    grep -v 'echo ""' /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                    grep -v "myarch.jsonc" /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                elif [[ ${SHELL,,} =~ "bash" ]]; then
                    grep -v 'echo ""'  ~/.bashrc > ~/.tmp_user_bashrc
                    sudo mv ~/.tmp_user_bashrc  ~/.bashrc
                    grep -v "myarch.jsonc"  ~/.bashrc > ~/.tmp_user_bashrc
                    sudo mv ~/.tmp_user_bashrc  ~/.bashrc

                    grep -v 'echo ""' /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                    grep -v "myarch.jsonc" /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                fi
            fi
        else
            sudo pacman -S fastfetch
            cd assets
            mkdir ~/.config/fastfetch
            cp cust_myarch.jsonc ~/.config/fastfetch/
            if [[ ${SHELL,,} =~ "zsh" ]]; then
                echo "${white}Identified standard shell: ${blue}ZSH${nocolor}"
                echo 'echo ""' >> ~/.zshrc
                echo "fastfetch -c ~/.config/fastfetch/cust_myarch.jsonc" >> ~/.zshrc
                echo 'echo ""' | sudo tee -a /root/.zshrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/cust_myarch.jsonc" | sudo tee -a /root/.zshrc > /dev/null
            elif [[ ${SHELL,,} =~ "bash" ]]; then
                echo "${white}Identified standard shell: ${blue}BASH${nocolor}"
                echo 'echo ""' >> ~/.bashrc
                echo "fastfetch -c ~/.config/fastfetch/cust_myarch.jsonc" >> ~/.bashrc
                echo 'echo ""' | sudo tee -a /root/.bashrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/cust_myarch.jsonc" | sudo tee -a /root/.bashrc > /dev/null
            fi
        fi
    fi
}

opt_chaotic(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Chaotic AUR repository...${nocolor}\n"
	sleep 2
    if [ "$(pacman -Qe chaotic-keyring | wc -l)" -ge 1 ] ; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ $input == "r" ]]; then
            sudo pacman -Rsnc chaotic-keyring chaotic-mirrorlist
            sudo sed -i '/\[chaotic-aur\]/c\' /etc/pacman.conf
            sudo sed -i '/Include = \/etc\/pacman.d\/chaotic-mirrorlist\/c\' /etc/pacman.conf

            sudo sed -i 's/\[chaotic-aur\]//g' /etc/pacman.conf
            sudo sed -i 's/Include = \/etc\/pacman\.d\/chaotic-mirrorlist//g' /etc/pacman.conf
        fi
        return
    else
		sudo pacman-key --recv-key 3056513887B78AEB --keyserver keyserver.ubuntu.com
		sudo pacman-key --lsign-key 3056513887B78AEB
		sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
		echo '[chaotic-aur]' | sudo tee -a /etc/pacman.conf > /dev/null
		echo 'Include = /etc/pacman.d/chaotic-mirrorlist' | sudo tee -a /etc/pacman.conf > /dev/null
		sudo pacman -Syu
    fi
}

opt_graphic_drivers(){
    clear
    echo -e "\n${white}#> ${blue}Installing AMD/Nvidia GPU drivers...${nocolor}\n"
	sleep 2
    read -p 'AMD or Nvidia? Just press [Enter] to skip. [a/n] ' input
    if [[ $input == "n" ]]; then
		sudo pacman -S --needed nvidia-dkms nvidia-settings nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia libvdpau libxnvctrl vulkan-icd-loader lib32-vulkan-icd-loader envycontrol nvtop
    elif [[ $input == "a" ]]; then
		sudo pacman -S --needed mesa lib32-mesa mesa-vdpau lib32-mesa-vdpau lib32-vulkan-radeon vulkan-radeon glu lib32-glu vulkan-icd-loader lib32-vulkan-icd-loader
    fi
}

opt_packages(){
    clear
    echo -e "\n${white}#> ${blue}Installing additional packages...${nocolor}\n"
	sleep 2
    read -p 'Do you want to edit pacman package list before installing? [y/N] ' input
    if [[ $input == "y" ]]; then
		nano ./assets/opt_pkglist-pacman.txt
    fi
    sudo pacman -S --needed - < ./assets/opt_pkglist-pacman.txt

    read -p 'Do you want to install additional yay packages? [y/N] ' input
    if [[ $input == "y" ]]; then
        check_4_yay
        read -p 'Do you want to edit yay package list before installing? [y/N] ' input
        if [[ $input == "y" ]]; then
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
    if [[ $input == "y" ]]; then
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
        if [[ $input == "y" ]]; then
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
        if [[ $input == "y" ]]; then
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
        if [[ $input == "y" ]]; then
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
        if [[ $input == "y" ]]; then
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
        if [[ $input == "y" ]]; then
            sudo systemctl disable tuned.service --now
            sudo systemctl disable tlp.service --now
            sudo pacman -Rsnc tlp tlp-rdw powertop tuned
        fi
    else
        sudo journalctl --vacuum-size=100M
        sudo journalctl --vacuum-time=2weeks
        read -p "Laptop or desktop? Just press [Enter] to skip. [l/d]" input
        sudo pacman -S tlp tlp-rdw powertop tuned
        sudo systemctl enable tuned.service --now
        sudo systemctl enable tlp.service --now
        sudo powertop --auto-tune
        if [[ $input == 'l' ]]; then
            sudo tuned-adm profile laptop-ac-powersave
        elif [[ $input == 'd' ]]; then
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
		if [[ $input == "y" ]]; then
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

set_reflector(){
    clear
    echo -e "\n${white}#> ${blue}reflector settings...${nocolor}\n"
	echo "     Country = $country"
	echo "     Fastest = $fastest (Mirrors)"
	echo "     Protocol = $protocol"
	echo "     Score = $score"
	echo ""
	read -p "Do you want to change settings? [y/N] " input
	if [[ $input == 'y' ]]; then
        echo -e "\n${white}#> ${blue}Enter a valid country or country code or nothing for all available mirrors.${nocolor}"
        echo -e "${white} ${blue}A list of countries separated by commas is possible, e.g. like France,sweden,de,CZ .${nocolor}"
        echo -e "${white}   ${blue}Press [l] for a list of available countries...${nocolor}\n"
        read -p "Country: " input
        until [ ! "$input" = "l" ] ;
        do
            reflector --list-countries
            read -p "Country: " input
        done
        country=$input
        cfg_write ./assets/arch_updater.conf country $input
        echo -e "\n${white}#> ${blue}Enter a number of how much of the fastest mirrors to save.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n amount of fastest mirrors: " input
        fastest=$input
        cfg_write ./assets/arch_updater.conf fastest $input
        echo -e "\n${white}#> ${blue}Enter the allowed protocol(s), like http,https,ftp${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "Protocol: " input
        protocol=$input
        cfg_write ./assets/arch_updater.conf protocol $input
        echo -e "\n${white}#> ${blue}Limit the list to the n servers with the highest score.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n amount of highest score mirrors: " input
        score=$input
        cfg_write ./assets/arch_updater.conf score $input
    fi
}
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
    if [ -n "$CHOICE" ]; then
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
                    echo -e "${magenta}|                                                            |${nocolor}";
                    echo -e "${magenta}| ${cyan}[ ${blue}b${cyan}] ${white}Back                                                  ${magenta}|${noclor}";
                    echo -e "${magenta}|                                                            |${nocolor}";
                    echo -e "${magenta}+----------------------------------< ${blue} by anonym0uz-trash ${magenta}>---+${nocolor}";
                    echo "";
                    read -p "#> " CHOICE
                    if [ -n "$CHOICE" ]; then
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
                            b)
                                ;;
                        esac
                        if [ $CHOICE != "b" ]; then
                            echo ""
                            read -p "Press any key to resume ..."
                        fi
                    fi
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
                    echo -e "${magenta}| ${cyan}[ ${blue}1${cyan}] ${white}Install Chaotic AUR Repository                        ${magenta}|${noclor}";
                    echo -e "${magenta}| ${cyan}[ ${blue}2${cyan}] ${white}Install AMD / Nvidia drivers                          ${magenta}|${noclor}";
                    echo -e "${magenta}| ${cyan}[ ${blue}3${cyan}] ${white}Install additional pacman / yay packages              ${magenta}|${noclor}";
                    echo -e "${magenta}| ${cyan}[ ${blue}4${cyan}] ${white}Get out of Wine dependency hell                       ${magenta}|${noclor}";
                    echo -e "${magenta}| ${cyan}[ ${blue}5${cyan}] ${white}Add Batocera Dual-Boot to system                      ${magenta}|${noclor}";
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
                    if [ -n "$CHOICE" ]; then
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
                        esac
                        if [ $CHOICE != "b" ]; then
                            echo ""
                            read -p "Press any key to resume ..."
                        fi
                    fi
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
                    if [ -n "$CHOICE" ]; then
                        case $CHOICE in
                            1)
                                set_reflector
                                ;;
                            b)
                                ;;
                        esac
                        if [ $CHOICE != "b" ]; then
                            echo ""
                            read -p "Press any key to resume ..."
                        fi
                    fi
                done
                ;;
            q)
                exit
                ;;
        esac
        if [ $CHOICE != "b" ]; then
            echo ""
            read -p "Press any key to resume ..."
        fi
        CHOICE=""
    fi
done
echo -e "${magenta}Script ${blue}terminated, Good bye..."
