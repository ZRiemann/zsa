#!/usr/bin/bash

sudo apt install xrdp
sudo systemctl enable --now xrdp
# sudo ufw allow from any to any port 3389 proto tcp

