#!/usr/bin/bash
# echo $(kdialog --password "sudo password required") | sudo -S wg-quick up skynet
pkexec wg-quick up skynet
