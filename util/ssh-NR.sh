#!/usr/bin/env bash

#read -p "Enter <remote-ip> <remote-passwd>: " R_IP R_PWD
R_IP=remote-ip
R_PWD=remote-pwd
echo "remote ip: $R_IP"
echo "remote pwd: $R_PWD"

echo sshpass -p ${R_PWD} autossh -nNT -M 2224 -R 2222:localhost:22 root@${R_IP}

exit 0
