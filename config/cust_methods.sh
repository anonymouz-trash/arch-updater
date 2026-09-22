#!/usr/bin/env bash

################################################################################
# manage_git_repo <label> <repo_url> <dir_name> <install_fn> [<uninstall_fn>]
#
# Shared lifecycle for every git-based Customization installer:
#   - not cloned yet  -> clone + install
#   - already cloned  -> ask: [u] check for updates & reinstall / [r] remove / [a] abort
#
# install_fn / uninstall_fn are the names of small, theme-specific functions.
# They are called with $PWD already set to the theme's directory inside
# ~/.cache/arch-updater, so they can just do things like "./install.sh ...".
#
# Always run from ~/.cache/arch-updater (created if missing).
################################################################################
manage_git_repo(){
    local label="$1" repo_url="$2" dir_name="$3" install_fn="$4" uninstall_fn="$5"

    mkdir -p ~/.cache/arch-updater
    cd ~/.cache/arch-updater || return 1

    if [[ -d "$dir_name" ]]; then
        echo -e "\n${white}[+] ${blue}${label} is already downloaded.${nocolor}"
        echo "  [u] Check for updates & (re)install"
        echo "  [r] Remove"
        echo "  [a] Abort"
        read -rp "Choice [u/r/a]: " choice
        case "${choice,,}" in
            r)
                if [[ -n "$uninstall_fn" ]]; then
                    (cd "$dir_name" && "$uninstall_fn")
                fi
                rm -rfv "./${dir_name}"
                return 0
                ;;
            u) ;;
            *)
                echo "Abort."
                return 1
                ;;
        esac
        echo -e "\n${white}[+] ${blue}Checking ${label} for updates...${nocolor}"
        (cd "$dir_name" && git pull)
    else
        echo -e "\n${white}[+] ${blue}${label} isn't installed yet, cloning...${nocolor}"
        git clone "$repo_url"
    fi

    if [[ ! -d "$dir_name" ]]; then
        echo -e "\n${red}[!] ${label}: repository not found after clone, aborting.${nocolor}"
        return 1
    fi

    (cd "$dir_name" && "$install_fn")

    echo
    read -rp "Remove the downloaded files now? Press [Enter] to keep them for future updates. [y/N] " input
    if [[ ${input,,} == "y" ]]; then
        rm -rfv "./${dir_name}"
    fi
}

################################################################################

cust_grub_arch_silence(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Arch Silence GRUB theme...${nocolor}\n"
    sleep 2
    if [ "$(pacman -Qe grub 2> /dev/null | wc -l)" -ge 1 ] ; then
        if [ -d "/boot/grub/themes/arch-silence_black-blue" ] || [ -d "/boot/grub/themes/arch-silence_black-red" ]; then
            read -p "Do you want to (r)emove it? [y/N] " input
            if [[ ${input} == "y" ]]; then
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
    else
        echo -e "\n${white}[+] ${blue}GRUB isn't installed, exiting...${nocolor}\n"
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_reversal(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Reversal icon theme...${nocolor}"
    sleep 2

    _cust_reversal_install(){ ./install.sh -a -t all; }
    _cust_reversal_uninstall(){ ./install.sh -u; }

    manage_git_repo "Reversal icon theme" \
        "https://github.com/yeyushengfan258/Reversal-icon-theme.git" \
        "Reversal-icon-theme" \
        _cust_reversal_install _cust_reversal_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_gtk_fluent(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Fluent GTK theme...${nocolor}"
    sleep 2

    _cust_gtk_fluent_install(){
        if [[ ${de,,} =~ "kde" ]]; then
            ./install.sh --theme all
        else
            ./install.sh --theme all --icon arch --libadwaita --tweaks float --tweaks rounded
        fi
    }
    _cust_gtk_fluent_uninstall(){ ./install.sh -u; }

    manage_git_repo "Fluent GTK theme" \
        "https://github.com/vinceliuice/Fluent-gtk-theme.git" \
        "Fluent-gtk-theme" \
        _cust_gtk_fluent_install _cust_gtk_fluent_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_kde_fluent(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Fluent KDE theme...${nocolor}"
    sleep 2

    _cust_kde_fluent_install(){
        ./install.sh --theme all --round
        sudo ./sddm/install.sh
    }
    _cust_kde_fluent_uninstall(){
        ./uninstall.sh
        sudo rm -rfv /usr/share/sddm/themes/Fluent*
    }

    manage_git_repo "Fluent KDE theme" \
        "https://github.com/vinceliuice/Fluent-kde.git" \
        "Fluent-kde" \
        _cust_kde_fluent_install _cust_kde_fluent_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_gtk_lavanda(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Lavanda GTK theme...${nocolor}"
    sleep 2

    _cust_gtk_lavanda_install(){
        if [[ ${de,,} =~ "kde" ]]; then
            ./install.sh
        else
            ./install.sh --libadwaita --icon arch
        fi
    }
    _cust_gtk_lavanda_uninstall(){ ./install.sh -u; }

    manage_git_repo "Lavanda GTK theme" \
        "https://github.com/vinceliuice/Lavanda-gtk-theme.git" \
        "Lavanda-gtk-theme" \
        _cust_gtk_lavanda_install _cust_gtk_lavanda_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_kde_lavanda(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Lavanda KDE theme...${nocolor}"
    sleep 2

    _cust_kde_lavanda_install(){
        ./install.sh
        sudo ./sddm/6.0/install.sh
    }
    _cust_kde_lavanda_uninstall(){
        ./uninstall.sh
        sudo rm -rfv /usr/share/sddm/themes/Lavanda*
    }

    manage_git_repo "Lavanda KDE theme" \
        "https://github.com/vinceliuice/Lavanda-kde.git" \
        "Lavanda-kde" \
        _cust_kde_lavanda_install _cust_kde_lavanda_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_gtk_layan(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Layan GTK theme...${nocolor}"
    sleep 2

    _cust_gtk_layan_install(){
        if [[ ${de,,} =~ "kde" ]]; then
            ./install.sh
        else
            ./install.sh --libadwaita
        fi
    }
    _cust_gtk_layan_uninstall(){ sudo ./install.sh -u; }

    manage_git_repo "Layan GTK theme" \
        "https://github.com/vinceliuice/Layan-gtk-theme.git" \
        "Layan-gtk-theme" \
        _cust_gtk_layan_install _cust_gtk_layan_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_kde_layan(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Layan KDE theme...${nocolor}"
    sleep 2

    _cust_kde_layan_install(){
        ./install.sh
        sudo ./sddm/6.0/install.sh
    }
    _cust_kde_layan_uninstall(){
        ./uninstall.sh
        sudo rm -rfv /usr/share/sddm/themes/Layan*
    }

    manage_git_repo "Layan KDE theme" \
        "https://github.com/vinceliuice/Layan-kde.git" \
        "Layan-kde" \
        _cust_kde_layan_install _cust_kde_layan_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_gtk_whitesur(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating WhiteSur GTK theme...${nocolor}"
    if [[ ${de,,} =~ "gnome" ]]; then
        echo -e "\n${white}[+] ${blue}!!!${nocolor} Please use background pictures without spaces in the filename ${blue}!!!${nocolor}"
    fi
    sleep 2

    _cust_gtk_whitesur_install(){
        if [[ ${de,,} =~ "gnome" ]]; then
            local curBg
            curBg="$(gsettings get org.gnome.desktop.background picture-uri | cut -d\' -f2 | cut -c 8-)"
            ./install.sh -o normal -c dark -t all -m -l -N stable --shell -i arch -b "${curBg}"
            sudo ./tweaks.sh -g -r
            sudo ./tweaks.sh -c Dark -g -i arch -b "$curBg"
        else
            ./install.sh -m -o normal -t all
        fi
    }
    _cust_gtk_whitesur_uninstall(){ sudo ./install.sh -r; }

    manage_git_repo "WhiteSur GTK theme" \
        "https://github.com/vinceliuice/WhiteSur-gtk-theme.git" \
        "WhiteSur-gtk-theme" \
        _cust_gtk_whitesur_install _cust_gtk_whitesur_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_kde_whitesur(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating WhiteSur KDE theme...${nocolor}"
    sleep 2

    _cust_kde_whitesur_install(){
        ./install.sh --opaque
        sudo ./sddm/install.sh
    }
    _cust_kde_whitesur_uninstall(){
        ./uninstall.sh
        sudo rm -rfv /usr/share/sddm/themes/WhiteSur*
    }

    manage_git_repo "WhiteSur KDE theme" \
        "https://github.com/vinceliuice/WhiteSur-kde.git" \
        "WhiteSur-kde" \
        _cust_kde_whitesur_install _cust_kde_whitesur_uninstall

    echo
    read -p "Press any key to resume ..."
}

cust_bibata(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing or updating Bibata cursor theme...${nocolor}\n"
	sleep 2
	if [[ ${app_yay} == "0" ]]; then
        install_yay
	fi
    if [ "$(yay -Qe bibata-cursor-theme | wc -l)" -ge 1 ]; then
        read -p "Already installed! Do you want to (r)emove it? [r/N] " input
        if [[ ${input} == "r" ]]; then
            yay -Rsnc bibata-cursor-theme
            return
        fi
    else
        yay -S bibata-cursor-theme
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_fastfetch(){
    clear
    draw_logo
    echo -e "\n${white}[+] ${blue}Installing / Removing fastfetch...${nocolor}\n"
	sleep 2
	if [ "$(pacman -Qe bash | wc -l)" -ge 1 ] || [ "$(pacman -Qe zsh | wc -l)" -ge 1 ] ; then
        echo -e "\n${white}[+] ${cyan}Neither BASH or ZSH are installed, aborting...${nocolor}\n"
        sleep 2
    else
        if [ "$(pacman -Qe fastfetch | wc -l)" -ge 1 ]; then
            read -p "Already installed! Do you want to (r)emove it? [r/N] " input
            if [[ ${input} == "r" ]]; then
                sudo pacman -Rsnc fastfetch
                rm -rf ~/.config/fastfetch
                if [[ ${SHELL,,} =~ "zsh" ]]; then
                    grep -v 'echo ""'  ~/.zshrc > ~/.tmp_user_zshrc
                    mv ~/.tmp_user_zshrc  ~/.zshrc
                    grep -v "customcfg.jsonc"  ~/.zshrc > ~/.tmp_user_zshrc
                    mv ~/.tmp_user_zshrc  ~/.zshrc

                    sudo grep -v 'echo ""' /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                    sudo grep -v "customcfg.jsonc" /root/.zshrc > ~/.tmp_root_zshrc
                    sudo mv ~/.tmp_root_zshrc /root/.zshrc
                elif [[ ${SHELL,,} =~ "bash" ]]; then
                    grep -v 'echo ""'  ~/.bashrc > ~/.tmp_user_bashrc
                    mv ~/.tmp_user_bashrc  ~/.bashrc
                    grep -v "customcfg.jsonc"  ~/.bashrc > ~/.tmp_user_bashrc
                    mv ~/.tmp_user_bashrc  ~/.bashrc

                    sudo grep -v 'echo ""' /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                    sudo grep -v "customcfg.jsonc" /root/.bashrc > ~/.tmp_root_bashrc
                    sudo mv ~/.tmp_root_bashrc /root/.bashrc
                fi
            fi
        else
            sudo pacman -S fastfetch
            cd assets
            mkdir -p ~/.config/fastfetch
            if [[ "${system_os}" == "SteamOS" ]]; then
                cp cust_steamos.jsonc ~/.config/fastfetch/customcfg.jsonc
            elif [[ "${system_os}" == "EndeavourOS" ]]; then
                cp cust_endeavouros.jsonc ~/.config/fastfetch/customcfg.jsonc
            elif [[ "${system_os}" == "CachyOS" ]]; then
                cp cust_cachyos.jsonc ~/.config/fastfetch/customcfg.jsonc
            elif [[ "${system_os}" == "Garuda Linux" ]]; then
                cp cust_garuda.jsonc ~/.config/fastfetch/customcfg.jsonc
            elif [[ "${system_os}" == "Manjaro" ]]; then
                cp cust_manjaro.jsonc ~/.config/fastfetch/customcfg.jsonc
            elif [[ "${system_os}" == "Arch Linux" ]]; then
                cp cust_arch.jsonc ~/.config/fastfetch/customcfg.jsonc
            fi
            if [[ ${SHELL,,} =~ "zsh" ]]; then
                echo "${white}Identified standard shell: ${blue}ZSH${nocolor}"
                echo 'echo ""' >> ~/.zshrc
                echo "fastfetch -c ~/.config/fastfetch/customcfg.jsonc" >> ~/.zshrc
                echo 'echo ""' >> ~/.zshrc
                echo 'echo ""' | sudo tee -a /root/.zshrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/customcfg.jsonc" | sudo tee -a /root/.zshrc > /dev/null
                echo 'echo ""' | sudo tee -a /root/.zshrc > /dev/null
            elif [[ ${SHELL,,} =~ "bash" ]]; then
                echo "${white}Identified standard shell: ${blue}BASH${nocolor}"
                echo 'echo ""' >> ~/.bashrc
                echo "fastfetch -c ~/.config/fastfetch/customcfg.jsonc" >> ~/.bashrc
                echo 'echo ""' >> ~/.bashrc
                echo 'echo ""' | sudo tee -a /root/.bashrc > /dev/null
                echo "fastfetch -c /home/${USER}/.config/fastfetch/customcfg.jsonc" | sudo tee -a /root/.bashrc > /dev/null
                echo 'echo ""' | sudo tee -a /root/.bashrc > /dev/null
            fi
        fi
    fi
    echo
    read -p "Press any key to resume ..."
}

cust_ohmyzsh(){
    clear
    draw_logo
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
