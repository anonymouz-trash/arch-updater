#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd
de=$XDG_CURRENT_DESKTOP

if [[ ${de,,} =~ "gnome" ]]; then
	exit
fi

# Check if WhiteSur got pulled and is up to date
if [ -d "MacSonoma-kde" ]; then
	read -p "Do you want to (r)emove or just update it? [r/U] " input
	if [[ $input == "r" ]]; then
		sudo ./MacSonoma/uninstall.sh
		rm -rf ./MacSonoma
		sudo rm -rf /usr/share/sddm/themes/MacSonoma*
	else
		cd MacSonoma-kde
		git pull
		cd ..
	fi
else
	git clone https://github.com/vinceliuice/MacSonoma-kde.git
fi

# Installation

sudo ./MacSonoma/install.sh
sudo ./MacSonoma/sddm/install.sh

if [ -d "MacSonoma-kde" ]; then
	echo "Do you want to remove previously downloaded files? "
	read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
	if [[ $input == "y" ]]; then
		rm -rf MacSonoma-kde
	fi
fi
