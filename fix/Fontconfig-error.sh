#!/bin/bash

# Fontconfig error: "/etc/fonts/conf.d/10-scale-bitmap-fonts.conf", line 72: non-double matrix element

sudo mv /etc/fonts/conf.d/10-scale-bitmap-fonts.conf /etc/fonts/conf.d/10-scale-bitmap-fonts.conf.backup

sudo fc-cache -fv | grep -i err