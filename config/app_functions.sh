#!/usr/bin/bash
# Get the directory from which the script is started
# This is useful if you plan to start the script via global hotkey
# because of the assets and the the use of relative paths
# pwd=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

# colors section
blue='\033[1;34m'
cyan='\033[1;36m'
magenta='\033[1;35m'
red='\033[1;31m'
white='\033[1;37m'
nocolor='\033[0m'

# Check current desktop
de=$XDG_CURRENT_DESKTOP

# set dialog theme
export DIALOGRC="$app_pwd/config/dialogrc"
