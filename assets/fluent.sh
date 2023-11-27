#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd $pwd

# Check if Fluent got pulled and is up to date
if [ -d "Fluent-gtk-theme" ]; then
	cd Fluent-gtk-theme
	git pull
else
	git clone https://github.com/vinceliuice/Fluent-gtk-theme.git
	cd Fluent-gtk-theme
fi

# Installation
./install.sh -t all -i arch -l --tweaks float --tweaks round --tweaks blur
