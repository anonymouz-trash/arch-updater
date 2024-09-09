#!/usr/bin/bash

cust_simple-arch-grub-theme(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Simple Arch Linux GRUB theme...${nocolor}\n"
    sleep 2
    if [ -d "/boot/grub/themes/arch-silence_black-blue" ] || [ -d "/boot/grub/themes/arch-silence_black-red" ]; then
        read -p "Do you want to (r)emove it? [y/N] " input
        if [ ${input} == "y" ]; then
            if [[ -d "/boot/grub/themes/arch-silence_black-blue" ]]; then
                sudo rm -rfv /boot/grub/themes/arch-silence_black-blue
            else
                sudo rm -rfv /boot/grub/themes/arch-silence_black-red
            fi
            sudo sed -i '/GRUB_THEME=/c\#GRUB_THEME=""' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    else
        read -p 'Do you want the blue or red Arch Linux GRUB theme? [b/r] ' input
        if [[ ${input} == "b" ]]; then
            sudo cp -rv ./assets/arch-silence_black-blue /boot/grub/themes
            sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-blue/theme.txt"' /etc/default/grub
        elif [[ ${input} == "r" ]];then
            sudo cp -rv ./assets/arch-silence_black-red /boot/grub/themes
            sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/arch-silence_black-red/theme.txt"' /etc/default/grub
        fi
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_xenlism-arch-grub-theme(){
    clear
    echo -e "\n${white}#> ${blue}Installing Xenlism Arch Linux GRUB theme...${nocolor}\n"
    sleep 2
    if [ -d "/boot/grub/themes/xenlism-grub-arch" ]; then
        read -p "Do you want to (r)emove it? [y/N] " input
        if [ ${input} == "y" ]; then
            sudo rm -rfv /boot/grub/themes/xenlism-grub-arch
            sudo sed -i '/GRUB_THEME=/c\#GRUB_THEME=""' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    else
        sudo cp -rv ./assets/xenlism-grub-arch /boot/grub/themes
        sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/xenlism-grub-arch/theme.txt"' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_rog-grub-theme(){
    clear
    echo -e "\n${white}#> ${blue}Installing Republic of Gamers GRUB theme...${nocolor}\n"
    sleep 2
    if [ -d "/boot/grub/themes/rog-grub-theme" ]; then
        read -p "Do you want to (r)emove it? [y/N] " input
        if [ ${input} == "y" ]; then
            sudo rm -rfv /boot/grub/themes/rog-grub-theme
            sudo sed -i '/GRUB_THEME=/c\#GRUB_THEME=""' /etc/default/grub
            sudo grub-mkconfig -o /boot/grub/grub.cfg
        fi
    else
        sudo cp -rv ./assets/rog-grub-theme /boot/grub/themes
        sudo sed -i '/GRUB_THEME=/c\GRUB_THEME="/boot/grub/themes/rog-grub-theme/theme.txt"' /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_colloid(){
    echo -e "\n${white}#> ${blue}Installing or updating Colloid icon theme...${nocolor}\n"
	sleep 2
    cd ~/.cache/arch-updater
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
    if [[ -d "Colloid-icon-theme" ]] ; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./Colloid-icon-theme
        fi
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

cust_obsidian(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Obsidian icon theme...${nocolor}\n"
	sleep 2
    cd ~/.cache/arch-updater
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
    if [[ -d "iconpack-obsidian" ]] ; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./iconpack-obsidian
        fi
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

cust_whitesur_icon(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating WhiteSur icon theme...${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
    if [ -d "WhiteSur-icon-theme" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ ${input} == "r" ]]; then
            rm -rfv ./WhiteSur-icon-theme
            sudo rm -rfv /usr/share/icons/WhiteSur*
            return
        else
            cd WhiteSur-icon-theme
            git pull
            cd ..
        fi
    else
        git clone https://github.com/vinceliuice/WhiteSur-icon-theme.git
    fi
    sudo ./WhiteSur-icon-theme/install.sh -d /usr/share/icons -a -t all
    if [[ -d "WhiteSur-icon-theme" ]] ; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./WhiteSur-icon-theme
        fi
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."
}

cust_lavanda(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Lavanda GTK/KDE theme...${nocolor}\n"
	sleep 2
	cd ~/.cache/arch-updater

	# Check if WhiteSur got pulled and is up to date
    if [ -d "Lavanda-gtk-theme" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ ${input} == "r" ]]; then
            sudo ./Lavanda-gtk-theme/install.sh -u
            rm -rf ./Lavanda-gtk-theme
            if [[ -d Lavanda-kde ]]; then
                sudo ./Lavanda-kde/uninstall.sh
                rm -rf ./Lavanda-kde
                sudo rm -rf /usr/share/sddm/themes/Lavanda*
            fi
        else
            cd Lavanda-gtk-theme
            git pull
            cd ..
            if [[ -d Lavanda-kde ]]; then
                cd Lavanda-kde
                git pull
                cd ..
            fi
        fi
    else
        git clone https://github.com/vinceliuice/Lavanda-gtk-theme.git
        if [[ ${de,,} =~ "kde" ]]; then
            git clone https://github.com/vinceliuice/Lavanda-kde.git
        fi
    fi
    sudo ${app_home}/.cache/arch-updater/Lavanda-gtk-theme/install.sh -d /usr/share/themes -l -i arch
    if [[ ${de,,} =~ "kde" ]]; then
        sudo ${app_home}/.cache/arch-updater/Lavanda-kde/install.sh
        sudo ${app_home}/.cache/arch-updater/Lavanda-kde/sddm/install.sh
    fi
    if [ -d "Lavanda-gtk-theme"]; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input

        if [[ ${input} == "y" ]]; then
            rm -rf Lavanda-gtk-theme
            if [ -d "Lavanda-kde" ]; then
                rm -rf Lavanda-kde
            fi
        fi
    fi
    echo
    read -p "Press any key to resume ..."
    cd ${pwd}
}

cust_whitesur(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating WhiteSur GTK/KDE theme...${nocolor}"
    echo -e "\n${blue}!!!${nocolor} Please use background pictures without spaces in the filename ${blue}!!!${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
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
    if [[ ${de,,} =~ "gnome" ]]; then
        curBg="$(gsettings get org.gnome.desktop.background picture-uri | cut -d\' -f2 | cut -c 8-)"
        ./WhiteSur-gtk-theme/install.sh -l -m -o normal -c Dark -t all -i arch -b "$curBg" -N glassy
        sudo $app_home/.cache/arch-updater/WhiteSur-gtk-theme/install.sh -m -o normal -t all -i arch -b "$curBg" -N glassy
        sudo $app_home/.cache/arch-updater/WhiteSur-gtk-theme/tweaks.sh -g -r
        sudo $app_home/.cache/arch-updater/WhiteSur-gtk-theme/tweaks.sh -g -b "$curBg" -c Dark -i arch
    elif [[ ${de,,} =~ "kde" ]]; then
        sudo $app_home/.cache/arch-updater/WhiteSur-gtk-theme/install.sh -m -o normal -t all
        sudo $app_home/.cache/arch-updater/WhiteSur-kde/install.sh --opaque
        sudo $app_home/.cache/arch-updater/WhiteSur-kde/sddm/install.sh
    fi
    if [ -d "WhiteSur-gtk-theme" ]; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input

        if [[ ${input} == "y" ]]; then
            rm -rf WhiteSur-gtk-theme
            if [ -d "WhiteSur-kde" ]; then
                rm -rf WhiteSur-kde
            fi
        fi
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_bibata(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Bibata cursor theme...${nocolor}\n"
	sleep 2
	check_4_yay
    if [ "$(yay -Qe bibata-cursor-theme | wc -l)" -ge 1 ]; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            yay -Rsnc bibata-cursor-theme-bin
            return
        fi
    else
        yay -S bibata-cursor-theme-bin
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_firefox(){
    clear
    echo -e "\n${white}#> ${blue}Installing or updating Firefox WhiteSur theme...${nocolor}\n"
    sleep 2
    cd ~/.cache/arch-updater
    if [ -d "WhiteSur-firefox-theme" ]; then
        read -p "Do you want to (r)emove or just update it? [r/U] " input
        if [[ ${input} == "r" ]]; then
            ./WhiteSur-firefox-theme/install.sh -r
            rm -rfv ./WhiteSur-firefox-theme
            return
        else
            cd WhiteSur-firefox-theme
            git pull
            cd ..
        fi
    else
        git clone https://github.com/vinceliuice/WhiteSur-firefox-theme.git
    fi
    ./WhiteSur-firefox-theme/install.sh -a
    if [[ -d "WhiteSur-firefox-theme" ]] ; then
        echo
        echo
        echo "Do you want to remove previously downloaded files? "
        read -p "Type (n) or just press [Enter] if you want to update in the future [y/N] " input
        if [[ ${input} == "y" ]]; then
            rm -rfv ./WhiteSur-firefox-theme
        fi
    fi
    cd ${pwd}
    echo
    read -p "Press any key to resume ..."


}

cust_fastfetch(){
    clear
    echo -e "\n${white}#> ${blue}Installing / Removing fastfetch...${nocolor}\n"
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
    echo
    read -p "Press any key to resume ..."
}

cust_tmux(){
    clear
    echo -e "\n${white}#> ${blue}Installing / Removing tmux...${nocolor}\n"
	sleep 2
	if [ "$(pacman -Qe tmux | wc -l)" -ge 1 ] && [ -f ~/.tmux.conf ] ; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            sudo pacman -Rsnc tmux
            rm -rf ~/.tmux.conf
        fi
    else
        sudo pacman -S tmux
        cp ./assets/cust_tmux.conf ~/.tmux.conf
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_ohmyzsh(){
    clear
    if [ "$(pacman -Qe zsh | wc -l)" -ge 1 ]; then
		echo "Install Oh My ZSH! for logged in user"
		sleep 1
		sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		echo "Install Oh My ZSH! for root"
		sleep 1
		sudo sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
		sed -i 's/robbyrussell/refined/g' ~/.zshrc
		sudo sed -i 's/robbyrussell/fox/g' /root/.zshrc
    else
        echo ">> no Z Shell installed, exiting..."
    fi
    echo
    read -p "Press any key to resume ..."
}
