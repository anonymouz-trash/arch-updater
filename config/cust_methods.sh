#!/usr/bin/bash

cust_conky-colors(){
	clear
	echo -e "\n${white}#> ${blue}Installing or updating Conky Colors...${nocolor}\n"
	sleep 2
	check_4_yay
	read -p "Do you want to (e)dit the conky-colors script before installing or (r)remove it? [e/r/N] " input
	if [[ ${input} == "e" ]]; then
		nano ./assets/conky-colors.sh
    elif [[ ${input} == "r" ]]; then
        if command -v  conky-colors &> /dev/null ; then
            yay -Rsnc conky-colors-git
            rm -rfv ~/.conky-colors
            return
        fi
	fi
	bash ./assets/conky-colors.sh
}

cust_conky-clock-weather(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Conky Clock with weather...${nocolor}\n"
	sleep 2
	if [ -d "/home/$USER/.conky/Clock-With-Weather-Conky" ]; then
        read -p "Do you want to (r)emove Conky clock with weather? [y/N] " input
        if [[ ${input} == "y" ]]; then
            killall conky
            rm -rfv ~/.conky
            return
        fi
		bash ~/.conky/Clock-With-Weather-Conky/scripts/setup.sh
	else
		if ! command -v wget &> /dev/null; then
            sudo pacman -S wget
        fi
		bash -c "$(wget --no-check-certificate --no-cache --no-cookies -O- https://raw.githubusercontent.com/takattila/Clock-With-Weather-Conky/v1.0.0/scripts/install.sh)"
	fi
}

cust_grub-theme(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating GRUB theme...${nocolor}\n"
	sleep 2
    sudo sed -i '/GRUB_DEFAULT=/c\GRUB_DEFAULT=saved' /etc/default/grub
    sudo sed -i '/GRUB_SAVEDEFAULT=/c\GRUB_SAVEDEFAULT=true' /etc/default/grub
    read -p 'Do you want the blue or red Arch Linux GRUB theme? [b/r] ' input
    if [[ ${input} == "b" ]]; then
      	sudo cp -rv ./assets/arch-silence_black-blue /boot/grub/themes
      	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-blue/theme.txt"' /etc/default/grub
    elif [[ ${input} == "r" ]];then
      	sudo cp -rv ./assets/arch-silence_black-red /boot/grub/themes
       	sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-red/theme.txt"' /etc/default/grub
    fi
    sudo grub-mkconfig -o /boot/grub/grub.cfg
}

cust_colloid(){
    echo -e "\n${white}#> ${blue}Installing or updating Colloid icon theme...${nocolor}\n"
	sleep 2
    cd assets
    if [ -d "Colloid-icon-theme" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ ${input} == "r" ]]; then
            rm -rfv ./Colloid-icon-theme
            sudo rm -rfv /usr/share/icons/Colloid*
            return
        else
            cd Colloid-icon-theme
            git pull
            cd ..
        fi
    else
        git clone https://github.com/vinceliuice/Colloid-icon-theme.git
    fi
    sudo ./Colloid-icon-theme/install.sh -d /usr/share/icons -s all -t all
    if [[ -d Colloid-icon-theme ]] ; then
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./Colloid-icon-theme
        fi
    fi
    cd ..
}

cust_obsidian(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Obsidian icon theme...${nocolor}\n"
	sleep 2
    cd assets
    if [ -d "iconpack-obsidian" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ ${input} == "r" ]]; then
            rm -rfv ./iconpack-obsidian
            sudo rm -rfv /usr/share/icons/Obsidian*
            return
        else
            cd iconpack-obsidian
            git pull
            cd ..
        fi
    else
        git clone https://github.com/madmaxms/iconpack-obsidian.git
    fi
    sudo cp -rv ./iconpack-obsidian/Obsidian* /usr/share/icons
    if [[ -d iconpack-obsidian ]] ; then
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./iconpack-obsidian
        fi
    fi
    cd ..
}

cust_lavanda(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Lavanda GTK/KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the Lavanda script before starting? [y/N] " input
	if [[ ${input} == "y" ]]; then
		nano ./assets/cust_lavanda.sh
	fi
	bash ./assets/cust_lavanda.sh
}

cust_macsonoma(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating MacSonoma KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the MacSonoma script before starting? [y/N] " input
	if [[ ${input} == "y" ]]; then
		nano ./assets/cust_macsonoma.sh
	fi
	bash ./assets/cust_macsonoma.sh
}

cust_whitesur(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating WhiteSur GTK/KDE theme...${nocolor}\n"
	sleep 2
	read -p "Do you want to edit the WhiteSur script before starting? [y/N] " input
	if [[ ${input} == "y" ]]; then
		nano ./assets/cust_whitesur.sh
	fi
	bash ./assets/cust_whitesur.sh
}

cust_bibata(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Bibata cursor theme...${nocolor}\n"
	sleep 2
	check_4_yay
    if [ "$(yay -Qe bibata-cursor-theme | wc -l)" -ge 1 ]; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            yay -Rsnc bibata-cursor-theme
            return
        fi
    else
        yay -S bibata-cursor-theme
    fi

}

cust_fastfetch(){
    clear
    echo -e "\n${white}#> ${blue}Installing or fastfetch...${nocolor}\n"
	sleep 2
	if [ "$(pacman -Qe bash | wc -l)" -ge 1 ] | [ "$(pacman -Qe bash | wc -l)" -ge 1 ] ; then
        echo -e "\n${white}#> ${cyan}Neither BASH or ZSH are installed, aborting...${nocolor}\n"
        sleep 2
    else
        if [ "$(pacman -Qe fastfetch | wc -l)" -ge 1 ]; then
            read -p "Already installed! Do you want to (r)emove it? [r/N] " input
            if [[ ${input} == "r" ]]; then
                sudo pacman -Rsnc fastfetch
                rm -rf ~/.config/fastfetch
                if [[ ${SHELL,,} =~ "zsh" ]]; then
                    grep -v 'echo ""'  ~/.zshrc > ~/.tmp_user_zshrc
                    sudo mv ~/.tmp_user_zshrc  ~/.zshrc
                    grep -v "myarch.jsonc"  ~/.zshrc > ~/.tmp_user_zshrc
                    sudo mv ~/.tmp_user_zshrc  ~/.zshrc

                    grep -v 'echo ""' /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                    grep -v "myarch.jsonc" /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                elif [[ ${SHELL,,} =~ "bash" ]]; then
                    grep -v 'echo ""'  ~/.bashrc > ~/.tmp_user_bashrc
                    sudo mv ~/.tmp_user_bashrc  ~/.bashrc
                    grep -v "myarch.jsonc"  ~/.bashrc > ~/.tmp_user_bashrc
                    sudo mv ~/.tmp_user_bashrc  ~/.bashrc

                    grep -v 'echo ""' /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                    grep -v "myarch.jsonc" /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                fi
            fi
        else
            sudo pacman -S fastfetch
            cd assets
            mkdir ~/.config/fastfetch
            cp cust_myarch.jsonc ~/.config/fastfetch/
            if [[ ${SHELL,,} =~ "zsh" ]]; then
                echo "${white}Identified standard shell: ${blue}ZSH${nocolor}"
                echo 'echo ""' >> ~/.zshrc
                echo "fastfetch -c ~/.config/fastfetch/cust_myarch.jsonc" >> ~/.zshrc
                echo 'echo ""' | sudo tee -a /root/.zshrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/cust_myarch.jsonc" | sudo tee -a /root/.zshrc > /dev/null
            elif [[ ${SHELL,,} =~ "bash" ]]; then
                echo "${white}Identified standard shell: ${blue}BASH${nocolor}"
                echo 'echo ""' >> ~/.bashrc
                echo "fastfetch -c ~/.config/fastfetch/cust_myarch.jsonc" >> ~/.bashrc
                echo 'echo ""' | sudo tee -a /root/.bashrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/cust_myarch.jsonc" | sudo tee -a /root/.bashrc > /dev/null
            fi
        fi
    fi
}
