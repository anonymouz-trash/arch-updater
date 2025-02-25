# Arch Linux Updater Script

This is a try to fully automate the Arch Linux maintainance and get a more knowledge of how Arch Linux works.
My setup:  Arch Linux (ofc ^^), KDE Desktop (sometimes GNOME) and AMD (Desktop) / Nvidia (Laptop) graphics.

Feel free to use any of the code in this repo for your own.
I highly encourage you to read through the script before you using it!
As you know: No backup, no mercy. ;)

# Prerequisites
* yay       (AUR-Helper)
* debtap    (for installing *.deb-packages)
* reflector (Updating Arch mirrorlist)
* bash
* zsh       (Please have a look at option 10 in main menu, if you just installed it, you to reboot!)

All programs will be installed automatically if not available.

# Usage
Just clone the repo and run it like below at any preferred location you want.
```
./arch-updater.sh
```

> Hint: Configure a global hotkey in your system to use it.

# Changelog

> Changing this script to Rolling Release. I'll just document the latest changes. You'll find additional info in commits section.

* Fixed: User/Pass input for SMB-Shares
* Update: Improved check procedure for Iconpack installation in Customization section

# Disclaimer

THIS IS WORK IN PROGRESS!!

I'm not responsible for any damage and I highly recommend to see through the entire project/code before using it!
The whole project is adjusted to my needs.

# Screenshots
![Arch Linux Updater - Main Menu](https://github.com/anonymouz-trash/arch-updater/blob/main/screenshots/arch-updater_mainmenu.png?raw=true)
![Arch Linux Updater - Main Menu](https://github.com/anonymouz-trash/arch-updater/blob/main/screenshots/arch-updater_customization.png?raw=true)
![Arch Linux Updater - Main Menu](https://github.com/anonymouz-trash/arch-updater/blob/main/screenshots/arch-updater_optimizations.png?raw=true)
