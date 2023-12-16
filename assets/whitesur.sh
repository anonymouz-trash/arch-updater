#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd
# Get actual set background of GNOME
curBg=$(gsettings get org.gnome.desktop.background picture-uri)
first=${curBg/\'file:\/\//}
second=${first/\'/}
curBg=$second

# Check if WhiteSur got pulled and is up to date
if [ -d "WhiteSur-gtk-theme" ]; then
	cd WhiteSur-gtk-theme
	git pull
else
	git clone https://github.com/vinceliuice/WhiteSur-gtk-theme.git
	cd WhiteSur-gtk-theme
fi

# Installation
./install.sh -l -m -o normal -c Dark -a normal -t all -i arch -b $curBg -N mojave
sudo ./tweaks.sh -g -r
sudo ./tweaks.sh -g -t purple -b $curBg -c Dark -i arch

read -p "Do you want to remove previously downloaded files? [Y/n]" input

if [[ $input == "n" ]]; then
	break;
else
	cd $pwd
	rm -rf WhiteSur-gtk-theme
fi