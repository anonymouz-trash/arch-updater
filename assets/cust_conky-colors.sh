#!/bin/bash
pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
cd ${pwd}

# Check for needed dependencies
if ! command -v  conky-colors &> /dev/null ; then
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

conky-colors --lang=de --theme=purple --arch --cpu=12 --cputemp --proc=10 --clock=modern --hd=mix --network --eth=0 --side=right --nvidia