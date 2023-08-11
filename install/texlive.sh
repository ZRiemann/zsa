#!/bin/bash

# install texlive

cd ~/Downloads/

sudo apt install fontconfig
sudo apt install perl
sudo apt install perl-tk
sudo apt install tk
sudo apt install perl-doc

# https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/texlive2023.iso
# wget https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/Images/texlive2023.iso
# https://mirrors.tuna.tsinghua.edu.cn/help/CTAN/

# remove texlive 2023
rm -rf /usr/local/texlive/2023
rm -rf ~/.texlive2023

# https://www.tug.org/texlive/quickinstall.html
# Post-install: setting PATH to  ~/.bashrc
PATH=/usr/local/texlive/2023/bin/x86_64-linux:$PATH
# Post-install: setting the default paper size
# Testing
latex small2e
# Update
tlmgr option repository https://mirrors.tuna.tsinghua.edu.cn/CTAN/systems/texlive/tlnet
tlmgr update --list
tlmgr update --all


exit 0
