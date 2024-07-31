#!/usr/bin/bash

### config read/write function
## Very nice, credits: https://unix.stackexchange.com/a/433816

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

# reflector settings
country=$(cfg_read ${pwd}/config/arch_updater.conf country)
fastest=$(cfg_read ${pwd}/config/arch_updater.conf fastest)
protocol=$(cfg_read ${pwd}/config/arch_updater.conf protocol)
score=$(cfg_read ${pwd}/config/arch_updater.conf score)

set_reflector(){
    clear
    echo -e "\n${white}#> ${blue}reflector settings...${nocolor}\n"
	echo "     Country = $country"
	echo "     Fastest = $fastest (Mirrors)"
	echo "     Protocol = $protocol"
	echo "     Score = $score"
	echo ""
	read -p "Do you want to change settings? [y/N] " input
	if [[ ${input} == 'y' ]]; then
        echo -e "\n${white}#> ${blue}Enter a valid country or country code or nothing for all available mirrors.${nocolor}"
        echo -e "${white} ${blue}A list of countries separated by commas is possible, e.g. like France,sweden,de,CZ .${nocolor}"
        echo -e "${white}   ${blue}Press [l] for a list of available countries...${nocolor}\n"
        read -p "Country: " input
        until [ ! "${input}" = "l" ] ;
        do
            reflector --list-countries
            read -p "Country: " input
        done
        country=${input}
        cfg_write ./config/arch_updater.conf country ${input}
        echo -e "\n${white}#> ${blue}Enter a number of how much of the fastest mirrors to save.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n amount of fastest mirrors: " input
        fastest=${input}
        cfg_write ./config/arch_updater.conf fastest ${input}
        echo -e "\n${white}#> ${blue}Enter the allowed protocol(s), like http,https,ftp${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "Protocol: " input
        protocol=${input}
        cfg_write ./config/arch_updater.conf protocol ${input}
        echo -e "\n${white}#> ${blue}Limit the list to the n servers with the highest score.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n amount of highest score mirrors: " input
        score=${input}
        cfg_write ./config/arch_updater.conf score ${input}
    fi
    echo
    read -p "Press any key to resume ..."
}

### Check if yay AUR helper is installed, if not it will be installed
check_4_yay(){
    if ! command -v yay &> /dev/null ; then
        echo -e "\n${white}#> ${blue}Yay is not installed, installing...${nocolor}\n"
        sudo pacman -S build-essential git
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si
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
    echo
    read -p "Press any key to resume ..."
}

update_pacman(){
	clear
	echo -e "\n${white}#> ${blue}Updating Arch Linux with pacman... ${nocolor}\n"
	sleep 2
	sudo pacman -Syyu
	echo
    read -p "Press any key to resume ..."
}

update_mirrorlist(){
	clear
	echo -e "\n${white}#> ${blue}Updating Arch Linux mirrorlist with reflector... ${nocolor}\n"
	sleep 2
	if ! command -v reflector &> /dev/null ; then
        sudo pacman -S reflector
        sudo systemctl enable reflector.timer --now
    fi
    sudo reflector -c ${country} -f ${fastest} -p ${protocol} --score ${score} --save /etc/pacman.d/mirrorlist --verbose
    echo
    read -p "Press any key to resume ..."
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
    echo

	if command -v yay &> /dev/null ; then
		echo
        read -p 'Do you want to clear all (y) cached packages or just the ones that are not installed (N)? [y/N] ' input
		if [[ ${input} == "y" ]]; then
			yay -Scc
		else
			yay -Sc
		fi
		echo -e "\n${cyan} This is a list of packages not used by anyone... ${nocolor}\n"
		yay -Qtdq
		read -p 'Do you want to remove these packages? [y/N] ' input
		if [[ ${input} == "y" ]]; then
			yay -Rns $(yay -Qtdq)
		fi
	fi

    read -p 'Do you want to delete the contents of ~/.cache directory? [y/N] ' input
    if [[ ${input} == "y" ]]; then
		rm -rfv ~/.cache/*
	else
        read -p 'Do you want to delete the contents of ~/.cache/yay directory? [y/N] ' input
        if [[ ${input} == "y" ]]; then
            rm -rfv ~/.cache/yay/*
        fi
	fi

	clear

	echo -e "${cyan} Size of current User's cache: ${nocolor}\n"
	du -sh ~/.cache
    echo
	echo -e "${cyan} Size of pacman cache: ${nocolor}\n"
	du -sh /var/cache/pacman/pkg
    echo
    echo
    read -p "Press any key to resume ..."
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
    echo
    read -p "Press any key to resume ..."
}
