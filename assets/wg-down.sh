#!/usr/bin/bash
# echo $(kdialog --password "sudo password required") | sudo -S wg-quick down skynet
pkexec wg-quick down skynet
