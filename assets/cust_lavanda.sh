#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd
de=$XDG_CURRENT_DESKTOP

# Check if WhiteSur got pulled and is up to date
if [ -d "Lavanda-gtk-theme" ]; then
	read -p "Do you want to (r)emove or just update it? [r/U] " input
	if [[ $input == "r" ]]; then
		sudo ./Lavanda-gtk-theme/install.sh -u
		rm -rf ./Lavanda-gtk-theme
		if [[ -d Lavanda-kde ]]; then
            sudo ./Lavanda-kde/uninstall.sh
			rm -rf ./Lavanda-kde
			sudo rm -rf /usr/share/sddm/themes/Lavanda*
		fi
	else
		cd Lavanda-gtk-theme
		git pull
		cd ..
		if [[ -d Lavanda-kde ]]; then
			cd Lavanda-kde
			git pull
			cd ..
		fi
	fi
else
	git clone https://github.com/vinceliuice/Lavanda-gtk-theme.git
	if [[ ${de,,} =~ "kde" ]]; then
		git clone https://github.com/vinceliuice/Lavanda-kde.git
	fi
fi

# Installation

if [[ ${de,,} =~ "gnome" ]]; then
	sudo ./Lavanda-gtk-theme/install.sh -d /usr/share/themes -l -i arch
elif [[ ${de,,} =~ "kde" ]]; then
	sudo ./Lavanda-kde/install.sh
	sudo ./Lavanda-kde/sddm/install.sh
fi

echo "Do you want to remove previously downloaded files? "
read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input

if [[ $input == "y" ]]; then
	rm -rf Lavanda-gtk-theme
	if [ -d "Lavanda-kde" ]; then
		rm -rf Lavanda-kde
	fi
fi
