#!/usr/bin/bash

if [ ! -d ~/.cache/arch-updater ]; then
	mkdir ~/.cache/arch-updater
	echo "cache dir created"
fi

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
if [ -f ~/.config/arch_updater.conf ]; then
    country=$(cfg_read ~/.config/arch_updater.conf country)
    age=$(cfg_read ~/.config/arch_updater.conf age)
    protocol=$(cfg_read ~/.config/arch_updater.conf protocol)
    latest=$(cfg_read ~/.config/arch_updater.conf latest)
fi

set_reflector(){
    clear
    echo -e "\n${white}[+] ${blue}reflector settings...${nocolor}\n"
	echo "     Country = $country"
	echo "     Age = $age"
	echo "     Protocol = $protocol"
	echo "     Latest = $latest"
	echo ""
	read -p "Do you want to change settings? [y/N] " input
	if [[ ${input} == 'y' ]]; then
        echo -e "\n${white}[+] ${blue}Enter a valid country or country code or nothing for all available mirrors.${nocolor}"
        echo -e "${white} ${blue}A list of countries separated by commas is possible, e.g. like France,sweden,de,CZ .${nocolor}"
        echo -e "${white}   ${blue}Press [l] for a list of available countries...${nocolor}\n"
        read -p "Country: " input
        until [ ! "${input}" = "l" ] ;
        do
            reflector --list-countries
            read -p "Country: " input
        done
        country=${input}
        cfg_write ~/.config/arch_updater.conf country ${input}
        echo -e "\n${white}[+] ${blue}Enter the max age in hours the mirrors should have.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n hours of last mirror update: " input
        age=${input}
        cfg_write ~/.config/arch_updater.conf age ${input}
        echo -e "\n${white}[+] ${blue}Enter the allowed protocol(s), like http or https${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "Protocol: " input
        protocol=${input}
        cfg_write ~/.config/arch_updater.conf protocol ${input}
        echo -e "\n${white}[+] ${blue}Limit the list to the latest n servers.${nocolor}"
        echo -e "${white}   ${blue}Or enter nothing to choose all alvailable.${nocolor}\n"
        read -p "n amount of latest mirrors: " input
        latest=${input}
        cfg_write ~/.config/arch_updater.conf latest ${input}
        echo
        read -p "Would you like to update the mirrorlist right now? [y/N]: " input
        if [[ ${input} = "y" ]]; then
            update_mirrorlist
        fi
    fi
}

### Check if yay AUR helper is installed, if not it will be installed
check_4_yay(){
    if ! command -v yay &> /dev/null ; then
        echo -e "\n${white}[+] ${blue}Yay is not installed, installing...${nocolor}\n"
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
    echo -e "\n${white}[+] ${blue}Updating Arch Linux with yay... ${nocolor}\n"
    sleep 2
	check_4_yay
    yay -Syyu
    echo
    read -p "Press any key to resume ..."
}

update_pacman(){
	clear
	echo -e "\n${white}[+] ${blue}Updating Arch Linux with pacman... ${nocolor}\n"
	sleep 2
	sudo pacman -Syyu
	echo
    read -p "Press any key to resume ..."
}

update_mirrorlist(){
	clear
	echo -e "\n${white}[+] ${blue}Updating Arch Linux mirrorlist with reflector... ${nocolor}\n"
	sleep 2
	if ! command -v reflector &> /dev/null ; then
        sudo pacman -S reflector rsync
        sudo systemctl enable reflector.timer --now
    fi
    sudo reflector -c ${country} -a ${age} -p ${protocol} -l ${latest} --sort rate --ipv4 --verbose --save /etc/pacman.d/mirrorlist
    echo
    read -p "Press any key to resume ..."
}

clean_arch(){
    clear
	echo -e "\n${white}[+] ${blue}Cleaning Arch Linux...${nocolor}\n"
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
		unused=$(yay -Qtdq)
		if [ "$(echo ${unused} | wc -l)" -gt 1 ]; then
            echo -e "\n${cyan} This is a list of packages not used by anyone... ${nocolor}\n"
            echo -e "${red}${unused}${nocolor}\n"
            read -p 'Do you want to remove these packages? [y/N] ' input
            if [[ ${input} == "y" ]]; then
                yay -Rns $(yay -Qtdq)
            fi
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
    echo -e "\n${white}[+] ${blue}Installing or updating debtap...${nocolor}\n"
	sleep 2
    check_4_yay
	if ! command -v debtap &> /dev/null ; then
		yay -S debtap
	fi
	sudo debtap -u
    echo
    read -p "Press any key to resume ..."
}
