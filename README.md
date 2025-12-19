# Arch Linux Updater Script

This is a try to fully automate the Arch Linux maintainance and get a more knowledge of how Arch Linux works.
My setup:  Arch Linux (ofc ^^), KDE Desktop (sometimes GNOME) and AMD (Desktop) / Nvidia (Laptop) graphics.

Feel free to use any of the code in this repo for your own.
I highly encourage you to read through the script before you using it!
As you know: No backup, no mercy. ;)

# Disclaimer
THIS IS WORK IN PROGRESS!!

I'm not responsible for any damage and I highly recommend to see through the entire project/code before using it!
The whole project is adjusted to my needs.

# Prerequisites
* dialog    (The menu itself)
* yay       (AUR-Helper)
* debtap    (for installing *.deb-packages)
* reflector (Updating Arch mirrorlist)
* bash      (Default shell on most systems)
* zsh       (Please have a look at option 9 in main menu, if you just installed it, you have to reboot!)

All programs will be installed automatically if not available.

# Usage
Just clone the repo and run it like below at any preferred location you want.
```
./start.sh
```

> Hint: Configure a global hotkey in your system to use it.

> Info: This script and its core functions, like updating, cleaning and installing packages, can used on nearly all Arch-based distros. If you are using Hyprland please read `Clean Arch`-Section, because during the process you get asked for cleaning `.cache`-directory and there maybe cached things that would be deleted like wallpapers. 

# Changelog
> Changing this script to Rolling Release. I'll just document the latest changes. You'll find additional info in commits section.

* Add:    preconfigured iptables ruleset (`check ./assets/opt_iptables.rules`)
* Add:    changed TUI to dialog with custom theming
* Misc:   Code cleanup

# Screenshots
![Arch Linux Updater - Main Menu](https://github.com/anonymouz-trash/arch-updater/blob/main/screenshots/arch-updater-dialog.png?raw=true)
