#!/bin/bash
cd ~
mkdir git
cd git
git config --global credential.helper store
git clone https://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@github.com/anonym0uz-trash/arch-updater.git
cd arch-updater
bash ./arch-updater.sh
