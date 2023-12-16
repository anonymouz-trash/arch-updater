#!/bin/bash
yay=0
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd
CYAN='\033[1;36m'
NOCOLOR='\033[0m'
ver=1.5
HEIGHT=20
WIDTH=75
CHOICE_HEIGHT=4
CHOICE="foobar"
BACKTITLE="PWD= $pwd"
TITLE="ALU - Arch Linux Updater $ver"
MENU="Choose one of the following options:"

OPTIONS=(1 "Update Arch Linux with yay"
         2 "Update Arch Linux without yay"
         3 "Update Arch Linux mirrorlist"
         4 "Install or update Debtap"
         5 "Install or update all of above"
         6 "Clean Arch Linux"
		 7 "Install apps and configure a fresh installation"
         8 ">> Conky, GRUB & GTK-Themes")

if ! command -v dialog &> /dev/null; then
	echo "This script needs the dialog package to run properly."
	read -p "Do you want to install dialog? [y/N] " input
	if [[ $input == "y" ]]; then
		sudo pacman -S dialog
	else
        	break;
	fi
fi

## methods
check_yay(){
	if ! command -v yay &> /dev/null; then
        sudo pacman -S build-essential git
        git clone https://aur.archlinux.com/yay.git
        cd yay
        sudo makepg -si
		echo -e "${CYAN} Yay installed... ${NOCOLOR}\n"
    fi
	yay=1
}

update_yay(){
	echo -e "${CYAN} Update Arch Linux with yay... ${NOCOLOR}\n"
	check_yay
	if [[ $yay == 1 ]]; then
		yay -Syu
	else
		echo -e "${CYAN} Yay is not installed...${NOCOLOR}\n"
	fi
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
	fi
	sudo reflector --threads 8 -c Germany -f 10 -p https --save /etc/pacman.d/mirrorlist --verbose
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
        sleep 3
}

clean_arch(){
	echo -e "${CYAN} Clean Arch Linux... ${NOCOLOR}\n"

	echo -e "${CYAN} Size of current user's cache: ${NOCOLOR}\n"
	du -sh ~/.cache

	echo -e "${CYAN} Size of pacman cache: ${NOCOLOR}\n"
	du -sh /var/cache/pacman/pkg

	if [[ $yay == 1 ]]; then
		read -p 'Do you want to clear all (y) cached packages or just the ones that are not installed (N)? [y/N] ' input
		if [[ $input == "y" ]]; then
			yay -Scc
		else
			yay -Sc
		fi
		echo -e "\n${CYAN} This is a list of pacman packages not used by anyone... ${NOCOLOR}\n"
		yay -Qtdq
		read -p 'Do you want to remove these packages? [y/N] ' input
		if [[ $input == "y" ]]; then
			yay -Rns $(yay -Qtdq)
		fi
	fi
	clear

	echo -e "${CYAN} Size of current User's cache: ${NOCOLOR}\n"
	du -sh ~/.cache

	echo -e "${CYAN} Size of pacman cache: ${NOCOLOR}\n"
	du -sh /var/cache/pacman/pkg

	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
    sleep 3
}

install_update_debtap(){
	echo -e "${CYAN} Install or update debtap... ${NOCOLOR}\n"
        sleep 3
	if ! command -v debtap &> /dev/null ; then
	    if ! command -v yay &> /dev/null; then
	            sudo pacman -S build-essential git
	            git clone https://aur.archlinux.com/yay.git
	            cd yay
	            sudo makepg -si
        fi
		yay -S debtap
	fi
	sudo debtap -u
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
	sleep 3
}

install_update_conky_colors(){
	echo -e "${CYAN} Install or update Conky-Colors... ${NOCOLOR}\n"
    sleep 3
	read -p "Do you want to edit the conky-colors script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/conky-colors.sh
	fi
	bash ./assets/conky-colors.sh
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
	read -p "Do you want to edit the WhiteSur script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/whitsur.sh
	fi
	bash ./assets/whitesur.sh
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
    sleep 3
}

install_update_fluent(){
	echo -e "${CYAN} Install or update Fluent-GTK-Theme... ${NOCOLOR}\n"
        sleep 3
	read -p "Do you want to edit the Fluent script before starting? [y/N] " input
	if [[ $input == "y" ]]; then
		nano ./assets/fluent.sh
	fi
	bash ./assets/fluent.sh
	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
    sleep 3
}

install_set_grub_theme(){
	echo ">> Copy GRUB theme and customize settings"
    sudo sed -i '/GRUB_DEFAULT=/c\GRUB_DEFAULT=saved' /etc/default/grub
    sudo sed -i '/GRUB_SAVEDEFAULT=/c\GRUB_SAVEDEFAULT=true' /etc/default/grub
    read -p 'Do you want the blue or red Arch Linux GRUB theme? Just pres [Enter] to skip. [b/r] ' input
    if [[ $input == "b" ]]; then
      	sudo cp -r ./assets/arch-silence_black-blue /boot/grub/themes
      	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-blue/theme.txt"' /etc/default/grub
    elif [[ $input == "r" ]];then
      	sudo cp -r ./assets/arch-silence_black-red /boot/grub/themes
       	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-red/theme.txt"' /etc/default/grub
    fi
    sudo grub-mkconfig -o /boot/grub/grub.cfg
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

	read -p 'Do you want to install AMD or Nvidia GPU drivers? Just press [Enter] to skip. [a/n] ' input

	if [[ $input == "n" ]]; then
		sudo pacman -S --needed nvidia nvidia-settings nvidia-utils lib32-nvidia-utils lib32-opencl-nvidia opencl-nvidia libvdpau libxnvctrl vulkan-icd-loader lib32-vulkan-icd-loader envycontrol nvtop
	elif [[ $input == "a" ]]; then
		sudo pacman -S --needed mesa lib32-mesa mesa-vdpau lib32-mesa-vdpau lib32-vulkan-radeon vulkan-radeon glu lib32-glu vulkan-icd-loader lib32-vulkan-icd-loader
	fi

	read -p 'Do you want to install additional pacman packages? [y/N] ' input

	if [[ $input == "y" ]]; then
		yay -S --needed - < ./assets/pkglist-pacman.txt
	fi

	read -p 'Do you want to install additional yay packages? [y/N] ' input

	if [[ $input == "y" ]]; then
		yay -S --needed - < ./assets/pkglist-yay.txt
	fi

	echo -e "${CYAN} Install WINE + dependencies and other gaming tools... ${NOCOLOR}\n"
	sleep 3	
	sudo pacman -S --needed wine-staging
	sudo pacman -S --needed giflib lib32-giflib libpng lib32-libpng libldap lib32-libldap gnutls lib32-gnutls mpg123 lib32-mpg123 openal lib32-openal v4l-utils lib32-v4l-utils libpulse lib32-libpulse alsa-plugins lib32-alsa-plugins alsa-lib lib32-alsa-lib libjpeg-turbo lib32-libjpeg-turbo libxcomposite lib32-libxcomposite libxinerama lib32-libxinerama ncurses lib32-ncurses opencl-icd-loader lib32-opencl-icd-loader libxslt lib32-libxslt libva lib32-libva gtk3 lib32-gtk3 gst-plugins-base-libs lib32-gst-plugins-base-libs vulkan-icd-loader lib32-vulkan-icd-loader cups samba dosbox
	yay -S --needed vkbasalt mangohud goverlay

    echo -e "${CYAN} Configure installed packages... ${NOCOLOR}\n"
    sleep 3

    echo ">> Copy webapp-icons for webapp-manager to ~/.icons/"
	cp -r ./assets/webapps ~/.icons

    echo ">> Copy boot menu entry file for Batocera"
    sudo cp ./assets/15_batocera /etc/grub.d/

    read -p 'Do you want to apply Arch Linux GRUB-Theme? [y/N] ' input

	if [[ $input == "y" ]]; then
		install_set_grub_theme
	fi
	
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

	read -p "Laptop or desktop? Just press [Enter] to skip. [l/d]" input

	if [[ $input == 'l' ]]; then
		echo "Improving laptop performance"
		sudo systemctl enable tuned.service --now
		sudo tuned-adm profile laptop-ac-powersave
	elif [[ $input == 'd' ]]; then
		echo "Improving desktop perfomance"
		sudo systemctl enable tuned.service --now
		sudo tuned-adm profile desktop
	fi

	if ! grep -Fxq "#SMB-Shares" /etc/fstab; then
		read -p "Do you want to add NAS drives to fstab? [y/N] " input
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
	
	read -p "Do you want to install debtap? [y/N] " input
	if [[ $input == y ]]; then
		install_update_debtap
	fi
	
	read -p "Do you want to install WhiteSur-GTK-Theme? [y/N] " input
	if [[ $input == y ]]; then
		install_update_whitesur
	fi
	
	read -p "Do you want to install conky-colors? [y/N] " input
	if [[ $input == y ]]; then
		install_update_conky_colors
	fi
	read -p "Do you want to install Conky-Clock-Weather? [y/N] " input
	if [[ $input == y ]]; then
		install_setup_clock_weather_conky
	fi

	read -p "Do you want to install Arch Linux GRUB-Theme? [y/N] " input
	if [[ $input == y ]]; then
		install_set_grub_theme
	fi

	echo -e "${CYAN} Finished... ${NOCOLOR}\n"
	echo "It's recommended to reboot the system now!"
	read -p "Do you want to reboot? [y/N] " input
	if [[ $input == "y" ]]; then
		sudo reboot
	fi
}

while [ -n  "$CHOICE"  ] ; 
do
	CHOICE=$(dialog --clear \
    	            --backtitle "$BACKTITLE" \
        	        --title "$TITLE" \
            	    --menu "$MENU" \
            		$HEIGHT $WIDTH $CHOICE_HEIGHT \
                	"${OPTIONS[@]}" \
                	2>&1 >/dev/tty)
	if [ -n "$CHOICE" ]
    then
		reset
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
            	install_update_debtap
        	   	;;
        	5)
            	update_mirrorlist
            	update_yay
            	install_update_debtap
            	;;
        	6)
        	    clean_arch
            	;;
			7)
		    	fresh_install
		    	;;
			8)
			# Submenu tryout
			OPTIONS_gfx=(1 "Install / update Conky-Colors"
 					  	 2 "Install / setup Conky Clock & Weather"
						 3 "Install / set GRUB-Theme"
         			  	 4 "Install / update WhiteSur-GTK-Theme"
						 5 "Install / update Fluent-GTK-Theme")
			CHOICE_gfx=$(dialog --clear \
                	--backtitle "$BACKTITLE" \
            		--title "$TITLE" \
                	--menu "$MENU" \
                	$HEIGHT $WIDTH $CHOICE_HEIGHT \
                	"${OPTIONS_gfx[@]}" \
                	2>&1 >/dev/tty)
			clear
			case $CHOICE_gfx in
       		1)
            	install_update_conky_colors
            	;;
        	2)
            	install_setup_clock_weather_conky
            	;;
        	3)
				install_set_grub_theme
				;;
			4)
            	install_update_whitesur
            	;;
			5)
				install_update_fluent
				;;
			esac
	esac
	fi
done


