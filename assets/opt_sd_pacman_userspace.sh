#!/bin/bash

# Steam Deck Userspace Pacman Setup Script
# This script sets up a userspace pacman installation on Steam Deck
# allowing package installations that persist across system updates

# Note from anonym0uz:
#
# This script I get from https://www.jeromeswannack.com/projects/2024/11/29/steamdeck-userspace-pacman.html
# Read the whole site carefully to understand what its doing.



# Exit on error, undefined variables, and propagate pipe errors
set -euo pipefail

# Helper function for logging
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1"
}

# Helper function for error handling
error() {
    log "ERROR: $1" >&2
    exit 1
}

# Check if running on Steam Deck
if ! grep -q "steamos" /etc/os-release; then
    error "This script must be run on Steam Deck"
fi

# Check if running as deck user
if [[ "$(whoami)" != "deck" ]]; then
    error "This script must be run as the deck user"
fi

# Set up main variables
USERROOT="/home/deck/.root"
PACMAN_CONF="$USERROOT/etc/pacman.conf"
GPG_DIR="$USERROOT/etc/pacman.d/gnupg"

# Create directory structure
log "Creating directory structure..."
mkdir -p "$USERROOT"/{etc,var/lib/pacman,dev,usr/lib/locale}

# Create essential device symlinks
log "Setting up device nodes..."
for dev in null zero random urandom; do
    if [[ ! -e "$USERROOT/dev/$dev" ]]; then
        sudo ln -s "/dev/$dev" "$USERROOT/dev/$dev"
    fi
done

# Copy and modify pacman configuration
log "Configuring pacman..."
if [[ ! -f "$PACMAN_CONF" ]]; then
    cp /etc/pacman.conf "$PACMAN_CONF"
    # Update DBPath in pacman.conf
    sed -i "s|^#\?DBPath.*|DBPath = $USERROOT/var/lib/pacman/|" "$PACMAN_CONF"
fi

# Initialize pacman keyring
log "Initializing pacman keyring..."
mkdir -p "$GPG_DIR"
sudo pacman-key --gpgdir "$GPG_DIR" --init
sudo pacman-key --gpgdir "$GPG_DIR" --populate archlinux
sudo pacman-key --gpgdir "$GPG_DIR" --populate holo

# Import and sign SteamOS keys
log "Importing SteamOS keys..."
sudo pacman-key --gpgdir "$GPG_DIR" --add /etc/pacman.d/gnupg/pubring.gpg
sudo pacman-key --gpgdir "$GPG_DIR" --lsign-key "GitLab CI Package Builder <ci-package-builder-1@steamos.cloud>"

# Define the environment setup
ENVSETUP="\
# Userspace pacman environment setup
export USERROOT=\"$USERROOT\"
export PATH=\"\$PATH:\$USERROOT/usr/bin\"
export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH:\$USERROOT/lib:\$USERROOT/lib64\"
export PERL5LIB=\"\$USERROOT/usr/share/perl5/vendor_perl:\$USERROOT/usr/lib/perl5/5.38/vendor_perl:\$USERROOT/usr/share/perl5/core_perl:\$USERROOT/usr/lib/perl5/5.38/core_perl\"
alias pacman_='sudo pacman -r \$USERROOT --config \$USERROOT/etc/pacman.conf --gpgdir \$USERROOT/etc/pacman.d/gnupg --dbpath \$USERROOT/var/lib/pacman --cachedir \$USERROOT/var/cache/pacman/pkg'
"

# Add environment setup to .bashrc if not already present
if ! grep -q "USERROOT=\"$USERROOT\"" ~/.bashrc; then
    log "Adding environment setup to .bashrc..."
    echo -e "\n$ENVSETUP" >> ~/.bashrc
fi

# Initial pacman sync
log "Syncing pacman databases..."
eval "$(echo "$ENVSETUP")"
pacman_ -Sy

log "Setup complete! Please:"
log "1. Open a new terminal"
log "2. Test the installation with 'pacman_ -S stow'"
log "3. Verify stow works with 'stow -h'"

# Note: The script has set up:
# - A userspace root at ~/.root
# - Pacman configuration and keyring
# - Required device nodes and directories
# - Environment variables and aliases in .bashrc
#
# You can now install packages with 'pacman_' and they will persist
# across Steam Deck system updates.
