#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd ~/.emacs.d

echo_msg "Install jade-mode"
echo

git clone https://github.com/brianc/jade-mode.git

echo "

;;;================================================================================
;;; Pug jade-mode
(add-to-list 'load-path \"~/.emacs.d/jade-mode\")
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '(\"\\.styl\\'\" . sws-mode))
" >> init.el

echo_inf "
$ npm install pug
$ npm install pug-cli -g
$ pug --help
"
npm install pug-cli -g
pug --help

cd $cmd_dir
exit 0