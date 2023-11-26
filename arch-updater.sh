#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd
CYAN='\033[0;36m'
NOCOLOR='\033[0m'
ver=1.3
HEIGHT=20
WIDTH=75
CHOICE_HEIGHT=4
BACKTITLE="PWD= $pwd"
TITLE="ALU - Arch Linux Updater $ver"
MENU="Choose one of the following options:"

OPTIONS=(1 "Update Arch Linux with yay"
         2 "Update Arch Linux without yay"
         3 "Update Arch Linux mirrorlist"
         4 "Clean Arch Linux"
         5 "Install or update Debtap"
         6 "Install or update Conky-Colors"
		 7 "Install or setup Clock-With-Weather-Conky"
         8 "Install or update WhiteSur-GTK-Theme"
         9 "Install apps and configure a fresh installation"
         10 "Install or update all of above")

if ! command -v dialog &> /dev/null; then
	echo "This script needs the dialog package to run properly."
	read -p "Do you want to install dialog? [y/n] " input
	if [[ $input == "y" ]]; then
		sudo pacman -S dialog
	else
        	break;
	fi
fi

CHOICE=$(dialog --clear \
                --backtitle "$BACKTITLE" \
                --title "$TITLE" \
                --menu "$MENU" \
                $HEIGHT $WIDTH $CHOICE_HEIGHT \
                "${OPTIONS[@]}" \
                2>&1 >/dev/tty)

update_yay(){
	echo -e "${CYAN} Update Arch Linux with yay... ${NOCOLOR}\n"
	yay -Syu
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

update_pacman(){
	echo -e "${CYAN} Update Arch Linux without yay... ${NOCOLOR}\n"
	sudo pacman -Syu
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

update_mirrorlist(){
	echo -e "${CYAN} Update Arch Linux mirrorlist... ${NOCOLOR}\n"
	if ! command -v reflector &> /dev/null ; then
		sudo pacman -S reflector
		sudo systemctl enable reflector.timer --now
	else
		sudo reflector --threads 8 -c Germany -f 10 -p https --save /etc/pacman.d/mirrorlist --verbose
	fi
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

clean_arch(){
	echo -e "${CYAN} Clean Arch Linux... ${NOCOLOR}\n"

	echo -e "${CYAN} Size of current User's cache: ${NOCOLOR}\n"
	sudo du -sh ~/.cache

	echo -e "${CYAN} Size of Pacman Cache: ${NOCOLOR}\n"
	sudo du -sh /var/cache/pacman/pkg

	if ! command -v yay &> /dev/null; then
                sudo pacman -S build-essential git
                git clone https://aur.archlinux.com/yay.git
                cd yay
                sudo makepg -si
        fi

	read -p 'Do you want to clear all (y) cached packages or just the ones that are not installed? [y/n] ' input

	if [[ $input == "y" ]]; then
		yay -Scc
	else
		yay -Sc
	fi

	echo -e "\n${CYAN} This is a list of pacman packages not used by anyone... ${NOCOLOR}\n"
	yay -Qtdq
	read -p 'Do you want to remove these packages? [y/n] ' input

	if [[ $input == "y" ]]; then
		yay -Rns $(yay -Qtdq)
	fi

	clear

	echo -e "${CYAN} Size of current User's cache: ${NOCOLOR}\n"
	sudo du -sh ~/.cache

	echo -e "${CYAN} Size of Pacman Cache: ${NOCOLOR}\n"
	sudo du -sh /var/cache/pacman/pkg

	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

install_update_debtap(){
	echo -e "${CYAN} Install or update debtap... ${NOCOLOR}\n"
        sleep 3
	if command -v debtap &> /dev/null ; then
		sudo debtap -u
	else
	        if ! command -v yay &> /dev/null; then
	                sudo pacman -S build-essential git
	                git clone https://aur.archlinux.com/yay.git
	                cd yay
	                sudo makepg -si
        	else
        	        yay -S debtap
        	fi
	fi
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

install_update_conky_colors(){
	echo -e "${CYAN} Install or update Conky-Colors... ${NOCOLOR}\n"
        sleep 3
	if command -v  conky-colors &> /dev/null ; then
		conky-colors --lang=de --theme=purple --arch --cpu=12 --cputemp --proc=10 --clock=modern --hd=mix --network --eth=0 --side=right --nvidia
	else
		if ! command -v yay &> /dev/null; then
			sudo pacman -S build-essential git
			git clone https://aur.archlinux.com/yay.git
			cd yay
			sudo makepg -si
			cd ..
			rm -rf yay
		else
			yay -S conky-colors-git
		fi
	fi
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

install_setup_clock_weather_conky(){
	echo -e "${CYAN} Install or setup Clock-With-Weather-Conky... ${NOCOLOR}\n"
        sleep 3
	if [ -d "/home/$USER/.conky/Clock-With-Weather-Conky" ]; then
		bash ~/.conky/Clock-With-Weather-Conky/scripts/setup.sh
	else
		if ! command -v wget &> /dev/null; then
                        sudo pacman -S wget
                fi
		bash -c "$(wget --no-check-certificate --no-cache --no-cookies -O- https://raw.githubusercontent.com/takattila/Clock-With-Weather-Conky/v1.0.0/scripts/install.sh)"
	fi
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

install_update_whitesur(){
	echo -e "${CYAN} Install or update WhiteSur-GTK-Theme... ${NOCOLOR}\n"
        sleep 3
	curBg=$(gsettings get org.gnome.desktop.background picture-uri)
	first=${curBg/\'file:\/\//}
	second=${first/\'/}
	curBg=$second
	if [ -d "WhiteSur-gtk-theme" ]; then
		cd WhiteSur-gtk-theme
		git pull
	else
		git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
		cd WhiteSur-gtk-theme
	fi
	./install.sh -l -m -o normal -c Dark -a normal -t all -i arch -b $curBg -N mojave
	sudo ./tweaks.sh -g -r
	sudo ./tweaks.sh -g -t purple -b $curBg -c Dark -i arch
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

fresh_install(){
	echo -e "${CYAN} Install Chaotic-AUR Repo... ${NOCOLOR}\n"
        sleep 3
	# Install Chaotic-AUR Repo
	if pacman -Qs "chaotic-keyring" > /dev/null ; then
		sudo pacman -Syu
	else
		sudo pacman-key --recv-key FBA220DFC880C036 --keyserver keyserver.ubuntu.com
		sudo pacman-key --lsign-key FBA220DFC880C036
		sudo pacman -U 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-keyring.pkg.tar.zst' 'https://cdn-mirror.chaotic.cx/chaotic-aur/chaotic-mirrorlist.pkg.tar.zst'
		sudo echo "[chaotic-aur]" >> /etc/pacman.conf
		sudo echo "Include = /etc/pacman.d/chaotic-mirrorlist" >> /etc/pacman.conf
		sudo pacman -Syu
	fi

	echo -e "${CYAN} Install all wanted packages from pkglist-directory... ${NOCOLOR}\n"
        sleep 3

	read -p 'Do you want to install AMD or Nvidia GPU drivers? [a/n] ' input

	if [[ $input == "n" ]]; then
		sudo pacman -S --needed nvidia nvidia-settings nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia libvdpau libxnvctrl vulkan-icd-loader lib32-vulkan-icd-loader envycontrol nvtop
	elif [[ $input == "a" ]]; then
		sudo pacman -S --needed mesa lib32-mesa mesa-vdpau lib32-mesa-vdpau lib32-vulkan-radeon vulkan-radeon glu lib32-glu vulkan-icd-loader lib32-vulkan-icd-loader
	fi

	read -p 'Do you want to install additional pacman packages? [y/n] ' input

	if [[ $input == "y" ]]; then
		yay -S --needed - < ./assets/pkglist-pacman.txt
	fi

	read -p 'Do you want to install additional yay packages? [y/n] ' input

	if [[ $input == "y" ]]; then
		yay -S --needed - < ./assets/pkglist-yay.txt
	fi

	echo -e "${CYAN} Install WINE + dependencies and other gaming tools... ${NOCOLOR}\n"
		sudo pacman -S --needed wine-staging
		sudo pacman -S --needed giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
		yay -S --needed vkbasalt mangohud goverlay
        sleep 3

        echo -e "${CYAN} Configure installed packages... ${NOCOLOR}\n"
        sleep 3

        echo ">> Copy webapp-icons for webapp-manager to ~/.icons/"
	cp -r ./assets/webapps ~/.icons

        echo ">> Copy boot menu entry file for Batocera"
        sudo cp ./assets/15_batocera /etc/grub.d/

        echo ">> Copy GRUB theme and customize settings"
        sudo sed -i '/GRUB_DEFAULT=/c\GRUB_DEFAULT=saved' /etc/default/grub
        sudo sed -i '/GRUB_SAVEDEFAULT=/c\GRUB_SAVEDEFAULT=true' /etc/default/grub
        read -p 'Do you want the blue or red Arch Linux GRUB theme? [b/r] ' input
        if [[ $input == "b" ]]; then
        	sudo cp -r ./assets/arch-silence_black-blue /boot/grub/themes
        	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-blue/theme.txt"' /etc/default/grub
        elif [[ $input == "r" ]];then
        	sudo cp -r ./assets/arch-silence_black-red /boot/grub/themes
        	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-red/theme.txt"' /etc/default/grub
        fi
        sudo grub-mkconfig -o /boot/grub/grub.cfg

        echo ">> Disabling Wayland in GDM"
        sudo sed -i 's/#WaylandEnable/WaylandEnable/g' /etc/gdm/custom.conf

        echo ">> Activate gamemode"
        systemctl --user enable gamemoded.service --now

	echo ">> Install missing fonts"
	sudo pacman -S --needed noto-fonts noto-fonts-cjk ttf-dejavu ttf-liberation ttf-opensans

	echo ">> Enabling ClearType rendering"
	yay -S --needed freetype2
	sudo ln -s /etc/fonts/conf.avail/70-no-bitmaps.conf /etc/fonts/conf.d
	sudo ln -s /etc/fonts/conf.avail/10-sub-pixel-rgb.conf /etc/fonts/conf.d
	sudo ln -s /etc/fonts/conf.avail/11-lcdfilter-default.conf /etc/fonts/conf.d
	sudo sed -i 's/#export/export/g' /etc/profile.d/freetype2.sh

	echo "Improving I/O performance"
	sudo cp ./assets/60-ioschedulers.rules /etc/udev/rules.d
	sudo systemctl enable fstrim.timer --now
	sudo systemctl enable reflector.timer --now

        echo "Improving laptop battery life"
        sudo systemctl enable tlp.service --now
        sudo powertop --auto-tune

        echo "Taming the jounal's size"
        sudo journalctl --vacuum-size=100M
	sudo journalctl --vacuum-time=2weeks

	read -p "Laptop or desktop? [l/d] " input

	if [[ $input == 'l' ]]; then
		echo "Improving laptop performance"
		sudo systemctl enable tuned.service --now
		sudo tuned-adm profile laptop-ac-powersave
	else
		echo "Improving desktop perfomance"
		sudo systemctl enable tuned.service --now
		sudo tuned-adm profile desktop
	fi
	if ! grep -Fxq "#SMB-Shares" /etc/fstab; then
		read -p "Do you want to add NAS drives to fstab? [y/n] " input
		if [[ $input == "y" ]]; then
			sudo cat ./assets/nas-smb-mount.txt >> /etc/fstab
			sudo cp ./assets/nas-smb-acc.txt /etc/samba/cred
			sudo chmod 600 /etc/samba/cred
			sudo systemctl daemon-reload
		fi
	fi
	if pacman -Qs zsh > /dev/null; then
		echo ">> Change standard shell to ZSH for tommy"
		chsh -s $(which zsh) tommy
		echo ">> Change standard shell to ZSH for root"
		sudo chsh -s $(which zsh)
		echo "Install Oh My ZSH! for tommy"
		terminator -e sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		echo "Install Oh My ZSH! for root"
		sudo terminator -e sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		echo "neofetch" >> /home/tommy/.zshrc
		sudo echo "neofetch" >> /root/.zshrc
	fi
	read -p "Do you want to install debtap? [y/n] " input
	if [[ $input == y ]]; then
		install_update_debtap
	fi
	read -p "Do you want to install WhiteSur-GTK-Theme? [y/n] " input
	if [[ $input == y ]]; then
		install_update_whitesur
	fi
	read -p "Do you want to install conky-colors? [y/n] " input
	if [[ $input == y ]]; then
		install_update_conky_colors
	fi
	read -p "Do you want to install Conky-Clock-Weather? [y/n] " input
	if [[ $input == y ]]; then
		install_setup_clock_weather_conky
	fi
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
	echo "It's recommended to reboot the system now!"
	read -p "Do you want to reboot? [y/n] " input
	if [[ $input == "y" ]]; then
		sudo reboot
	fi
}
clear
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
            clean_arch
            ;;
        5)
            install_update_debtap
            ;;
        6)
            install_update_conky_colors
            ;;
		7)
	    	install_setup_clock_weather_conky
	    	;;
        8)
            install_update_whitesur
            ;;
        9)
            fresh_install
            ;;
        10)
            update_mirrorlist
            update_yay
            install_update_debtap
            install_update_whitesur
            ;;
esac
