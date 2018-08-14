#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_msg "Installing youtube-dl"
echo

if [ ! -f /usr/local/bin/youtube-dl ]; then
    sudo wget https://yt-dl.org/downloads/latest/youtube-dl -O /usr/local/bin/youtube-dl
    sudo chmod a+rx /usr/local/bin/youtube-dl
fi

echo inf "usage:"
echo msg "youtube-dl <VIDEO_URL>"
echo inf "youtube-dl -F http://www.youtube.com/watch?v=BlXaGWbFVKY  # 列出支持的格式"
echo inf "youtube-dl -f 17 http://www.youtube.com/watch?v=BlXaGWbFVKY # 下载指定格式"

cd $cmd_dir
exit 0