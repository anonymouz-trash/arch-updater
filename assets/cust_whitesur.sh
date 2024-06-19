#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${pwd}

de=$XDG_CURRENT_DESKTOP

# Check if WhiteSur got pulled and is up to date
if [ -d "WhiteSur-gtk-theme" ]; then
	read -p "Do you want to (r)emove or just update it? [r/U] " input
	if [[ ${input} == "r" ]]; then
		sudo ./WhiteSur-gtk-theme/install.sh -r
		rm -rf ./WhiteSur-gtk-theme
		if [[ -d WhiteSur-kde ]]; then
            rm -rf ./WhiteSur-kde
			sudo rm -rf /usr/share/themes/WhiteSur*
			sudo rm -rf /usr/share/sddm/themes/WhiteSur*
		fi
	else
		cd WhiteSur-gtk-theme
		git pull
		cd ..
		if [[ -d WhiteSur-kde ]]; then
			cd WhiteSur-kde
			git pull
			cd ..
		fi
	fi
else
	git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
	if [[ ${de,,} =~ "kde" ]]; then
		git clone https://github.com/vinceliuice/WhiteSur-kde.git
	fi
fi

# Installation

if [[ ${de,,} =~ "gnome" ]]; then
	# Get actual set background of GNOME
	curBg="$(gsettings get org.gnome.desktop.background picture-uri | cut -d\' -f2 | cut -c 8-)"
	./WhiteSur-gtk-theme/install.sh -l -m -o normal -c Dark -t all -i arch -b "$curBg" -N glassy
	# su root -c "./WhiteSur-gtk-theme/install.sh -d /usr/share/themes -l -m -o normal -c Dark -t all -i arch -b "$curBg" -N glassy"
	sudo ./WhiteSur-gtk-theme/tweaks.sh -g -r
	sudo ./WhiteSur-gtk-theme/tweaks.sh -g -b "$curBg" -c Dark -i arch
	until [ $(pgrep -c firefox) -eq 0 ] ;
	do
		echo -e "\nFirefox is running, please close it to proceed...\n"
		read -p "Press [Enter] to check again..."
	done 
	sudo ./WhiteSur-gtk-theme/tweaks.sh -f monterey
elif [[ ${de,,} =~ "kde" ]]; then
	sudo ./WhiteSur-kde/install.sh -c dark --opaque
	sudo ./WhiteSur-kde/sddm/install.sh
fi

echo "Do you want to remove previously downloaded files? "
read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input

if [[ ${input} == "y" ]]; then
	rm -rf WhiteSur-gtk-theme
	if [ -d "WhiteSur-kde" ]; then
		rm -rf WhiteSur-kde
	fi
fi
