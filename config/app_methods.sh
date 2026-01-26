#!/usr/bin/env bash

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

### Check if dialog is installed, if not it will be installed
check_4_dialog(){
    if ! command -v dialog &> /dev/null ; then
        echo -e "\n${white}[+] ${blue}dialog is not installed, installing...${nocolor}\n"
        sudo ${pacman_cmd} -S dialog --noconfirm
    fi
}

### install yay AUR helper
install_yay(){
    if ! command -v yay &> /dev/null ; then
        echo -e "\n${white}[+] ${blue}Yay is not installed, installing...${nocolor}\n"
        if [ "$(${pacman_cmd} -Qe chaotic-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
            sudo ${pacman_cmd} -S yay
        else
            sudo ${pacman_cmd} -S fakeroot debugedit git
            git clone https://aur.archlinux.org/yay.git
            cd yay
            makepkg -si
            cd ..
            rm -rf yay
        fi
        echo -e "\n${white}[+] ${blue}Yay should be installed. Please run operation again...${nocolor}\n"
    fi
}

update_arch(){
    clear
    echo -e "\n${white}[+] ${blue}Updating Arch Linux... ${nocolor}\n"
    sleep 2
	if [[ ${app_yay} == "1" ]]; then
        echo -e "${white}[+] ${blue}...using yay ${nocolor}\n"
        yay -Syu
    else
        echo -e "${white}[+] ${blue}...using pacman ${nocolor}\n"
        sudo pacman -Syu
    fi
    if [[ ${app_flatpak} == "1" ]]; then
        echo -e "\n${white}[+] ${blue}...updating flatpaks ${nocolor}\n"
        flatpak update
    fi
    echo
    read -p "Press any key to resume ..."
}

update_mirrorlist(){
	clear
	echo -e "\n${white}[+] ${blue}Updating Arch Linux mirrorlist with reflector... ${nocolor}\n"
	sleep 2
	if ! command -v reflector &> /dev/null ; then
        sudo ${pacman_cmd} -S reflector rsync
        sudo systemctl enable reflector.timer --now
    fi
    if [ -f /etc/xdg/reflector/reflector.conf ]; then
        sudo rm /etc/xdg/reflector/reflector.conf
    fi
    echo "--country ${country}" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--age ${age}" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--protocol ${protocol}" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--latest ${latest}" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--sort rate" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--ipv4" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    echo "--save ${PACMAN_DIR}/mirrorlist" | sudo tee -a /etc/xdg/reflector/reflector.conf > /dev/null
    sudo reflector -c ${country} -a ${age} -p ${protocol} -l ${latest} --sort rate --ipv4 --verbose --save ${PACMAN_DIR}/mirrorlist
    sudo ${pacman_cmd} -S archlinux-keyring
    if [ "$(${pacman_cmd} -Qe chaotic-keyring 2> /dev/null | wc -l)" -ge 1 ] ; then
        sudo ${pacman_cmd} -S chaotic-keyring
    fi
    echo
    read -p "Press any key to resume ..."
}

clean_arch(){
    clear
	echo -e "\n${white}[+] ${blue}Cleaning Arch Linux...${nocolor}\n"
    cache_size=$(du -sh ~/.cache)
    paccache_size=$(du -sh /var/cache/pacman/pkg)
    sleep 2
	echo -e "${cyan} Size of current user's cache: ${nocolor}  ${cache_size}\n"
	echo -e "${cyan} Size of pacman cache:         ${nocolor}  ${paccache_size}\n"
    echo
	if command -v yay &> /dev/null ; then
		echo
        read -p 'Do you want to clear all (y) cached packages or just the ones that are not installed (N)? [y/N] ' input
		if [[ ${input} == "y" ]]; then
			if [[ ${app_yay} == "1" ]]; then
                yay -Scc
            else
                sudo pacman -Scc
            fi
		else
            if [[ ${app_yay} == "1" ]]; then
                yay -Sc
            else
                sudo pacman -Sc
            fi
		fi
		unused=$(pacman -Qtdq)
		if [ "$(echo ${unused} | wc -l)" -ge 1 ]; then
            echo -e "\n${cyan} This is a list of packages not used by anyone... ${nocolor}\n"
            echo -e "${red}${unused}${nocolor}\n"
            read -p 'Do you want to remove these packages? [y/N] ' input
            if [[ ${input} == "y" ]]; then
                sudo pacman -Rnsc $(yay -Qtdq)
            fi
        fi
	fi
	echo
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
	cache_size=$(du -sh ~/.cache)
    paccache_size=$(du -sh /var/cache/pacman/pkg)
    echo
    echo -e "${cyan} Size of current user's cache: ${nocolor}  ${cache_size}\n"
    echo -e "${cyan} Size of pacman cache:         ${nocolor}  ${paccache_size}\n"
    echo
    read -p "Press any key to resume ..."
    unset paccache_size cache_size unused input
}
