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

# Parameter for installation

# Usage: ./git/arch-updater/assets/WhiteSur-gtk-theme/install.sh [OPTIONS...]

# OPTIONS:
#   -d, --dest DIR
#  Set destination directory. Default is '/home/tommy/.themes'

#   -n, --name NAME
#  Set theme name. Default is 'WhiteSur'

#   -o, --opacity [normal|solid]
#  Set theme opacity variants. Repeatable. Default is all variants

#   -c, --color [Light|Dark]
#  Set theme color variants. Repeatable. Default is all variants

#   -a, --alt [normal|alt|all]
#  Set window control buttons variant. Repeatable. Default is 'normal'

#   -t, --theme [default|blue|purple|pink|red|orange|yellow|green|grey|all]
#  Set theme accent color. Repeatable. Default is BigSur-like theme

#   -p, --panel-opacity [default|30|45|60|75]
#  Set panel transparency. Default is 15%

#   -P, --panel-size [default|smaller|bigger]
#  Set Gnome shell panel height size. Default is 32px

#   -s, --size [default|180|220|240|260|280]
#  Set Nautilus sidebar minimum width. Default is 200px

#   -i, --icon [standard|simple|gnome|ubuntu|tux|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin|budgie|gentoo]
#  Set 'Activities' icon. Default is 'standard'

#   -b, --background [default|blank|IMAGE_PATH]
#  Set gnome-shell background image. Default is BigSur-like wallpaper

#   -m, --monterey 
#  Set to MacOS Monterey style. 

#   -N, --nautilus-style [stable|normal|mojave|glassy]
#  Set Nautilus style. Default is BigSur-like style (stabled sidebar)

#   -l, --libadwaita 
#  Install theme into gtk4.0 config for libadwaita. Default is dark version

#   -HD, --highdefinition 
#  Set to High Definition size. Default is laptop size

#   --normal, --normalshowapps 
#  Set gnome-shell show apps button style to normal. Default is BigSur

#   --default, --defaultactivities 
#  Set gnome-shell panel activities button style to system default. Default is Apple icon

#   --round, --roundedmaxwindow 
#  Set maximized window to rounded. Default is square

#   --right, --rightplacement 
#  Set Nautilus title button placement to right. Default is left

#   --black, --blackfont 
#  Set panel font color to black. Default is white

#   --darker, --darkercolor 
#  Install darker 'WhiteSur' dark themes. 

#   --nord, --nordcolor 
#  Install 'WhiteSur' Nord ColorScheme themes. 

#   --dialog, --interactive 
#  Run this installer interactively, with dialogs. 

#   --silent-mode 
#  Meant for developers: ignore any confirm prompt and params become more strict. 

#   -r, --remove, -u, --uninstall 
#  Remove all installed WhiteSur themes. 

#   -h, --help 
#  Show this help. 

# Usage: ./git/arch-updater/assets/WhiteSur-gtk-theme/tweaks.sh [OPTIONS...]

# OPTIONS:
#   [GDM theme] options
#  ................... 

#   -g, --gdm [default|x2]
#  Install 'WhiteSur' theme for GDM (scaling: 100%/200%, default is 100%). Requires to run this shell as root

#   -o, --opacity [normal|solid]
#  Set 'WhiteSur' GDM theme opacity variants. Default is 'normal'

#   -c, --color [Light|Dark]
#  Set 'WhiteSur' GDM and Dash to Dock theme color variants. Default is 'light'

#   -t, --theme [default|blue|purple|pink|red|orange|yellow|green|grey]
#  Set 'WhiteSur' GDM theme accent color. Default is BigSur-like theme

#   -N, --no-darken 
#  Don't darken 'WhiteSur' GDM theme background image. 

#   -n, --no-blur 
#  Don't blur 'WhiteSur' GDM theme background image. 

#   -b, --background [default|blank|IMAGE_PATH]
#  Set 'WhiteSur' GDM theme background image. Default is BigSur-like wallpaper

#   -p, --panel-opacity [default|30|45|60|75]
#  Set 'WhiteSur' GDM (GNOME Shell) theme panel transparency. Default is 15%

#   -P, --panel-size [default|smaller|bigger]
#  Set 'WhiteSur' Gnome shell panel height size. Default is 32px

#   -i, --icon [standard|simple|gnome|ubuntu|tux|arch|manjaro|fedora|debian|void|opensuse|popos|mxlinux|zorin|budgie|gentoo]
#  Set 'WhiteSur' GDM (GNOME Shell) 'Activities' icon. Default is 'standard'

#   --nord, --nordcolor 
#  Install 'WhiteSur' Nord ColorScheme themes. 

#   [Others] options
#  ................... 

#   -f, --firefox [default|monterey|alt]
#  Install 'WhiteSur|Monterey|Alt' theme for Firefox and connect it to the current Firefox profiles. Default is WhiteSur

#   -e, --edit-firefox 
#  Edit 'WhiteSur' theme for Firefox settings and also connect the theme to the current Firefox profiles. 

#   -F, --flatpak 
#  Connect 'WhiteSur' theme to Flatpak. 

#   -d, --dash-to-dock 
#  Fixed Dash to Dock theme issue. 

#   -r, --remove, --revert 
#  Revert to the original themes, do the opposite things of install and connect. 

#   --silent-mode 
#  Meant for developers: ignore any confirm prompt and params become more strict. 

#   -h, --help 
#  Show this help.

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