# Arch Linux Updater Script

This is an attempt to fully automate Arch Linux maintenance and to gain a better understanding of how Arch Linux works along the way.
My setup: Arch Linux (of course ^^), KDE Plasma (sometimes GNOME), and AMD (desktop) / Nvidia (laptop) graphics.

Feel free to use any of the code in this repo for your own projects.
I highly encourage you to read through the script before using it!
As you know: no backup, no mercy. ;)

# Disclaimer

THIS IS WORK IN PROGRESS!!

I'm not responsible for any damage, and I highly recommend reviewing the entire project/code before using it!
The whole project is tailored to my own needs. As an Arch user, I assume you know what you're doing. :smile:

:warning: This script does **not** work on "immutable" SteamOS distros or derivatives like Bazzite. :warning:
:information_source: Feel free to check out my other project, [SteamOS Customizer](https://github.com/anonymouz-trash/steamos-customizer). :grin:

# Features

- Repeatable one-shot tasks for updating, cleaning, and installing packages (pacman, yay, flatpak)
- Automates the tedious setup work that comes with reinstalling the entire system
- Bundles the excellent Non-Steam-Launchers script for both desktop and Steam Deck
- Guided reflector/mirrorlist setup, with your choices persisted in `~/.config/arch_updater.conf`
- One-click theme installers for GTK & KDE (Fluent, Lavanda, Layan, WhiteSur), Bibata cursors, the Reversal icon theme, and an Arch Silence GRUB theme
- Repository helpers to add/remove Chaotic-AUR and CachyOS
- Gaming-focused extras: the archgaming script, gamescope, and a Battle.net-friendly `/etc/hosts` fix
- Quick installers for a WireGuard toggle script, a fan-profile script, and a preconfigured iptables ruleset
- Shows currently installed official & AUR packages and your environment variables at a glance
- Built-in self-updater (`git pull` right from the menu)
- Detects your distro/desktop and adapts its behavior accordingly (hopefully :grin:)
- Prompts you interactively whenever something is customizable, like which packages to install
- Zero external TUI dependency — the whole menu is pure Bash now, no more `dialog`

# Prerequisites

- yay (AUR helper), optional
- reflector (for updating the Arch mirrorlist)
- bash (default shell on most systems)
- zsh — only needed for the Oh My Zsh! installer in the Customization submenu; log back in (or reboot) afterwards for the shell change to take effect

Most of the above are installed automatically if missing.

# Usage

Just clone the repo and run it like below from any location you like:

```text
./start.sh
```

> Hint: Configure a global hotkey in your system to launch it.

# Changelog
> Switched this script to a rolling-release model. From here on, only the latest changes are documented — check the commit history for anything older.

- Add: a working method for a systemd user update-check service (Pacman, Yay, Flatpak)
- Add: Fluent [GTK](https://github.com/vinceliuice/Fluent-gtk-theme) & [KDE](https://github.com/vinceliuice/Fluent-kde) theme, Windows-like themes by [vinceliuice](https://github.com/vinceliuice)
- Removed: the distro-independent update-check systemd (user) service — it didn't work as expected
- Removed: Tmux installation + custom config

# Screenshots
![Arch Linux Updater - Main Menu](https://github.com/anonymouz-trash/arch-updater/blob/main/screenshots/arch-updater-main-menu.png?raw=true)
