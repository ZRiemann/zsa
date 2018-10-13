#!/bin/bash

cmd_dir=$(pwd)
cd ${0%/*}
cd ..

enable_dbg=0
. ./base.sh
cd /tmp/

echo_inf "Install SSR with: (server|client)"

cd $cmd_dir

sudo apt-get install pthon-m2crypto libsodium-dev

read pick
if [ "server" = "$pick" ]; then
    echo_inf "accept ssr port from firewall(开放防火墙对应端口)"
    echo_inf "sudo apt-get install git python-m2crypto libsodium18"

    sudo git clone -b manyuser https://github.com/shadowsocksrr/shadowsocksr.git
    cd shadowsocksr
    sudo bash initcfg.sh
    echo_inf "configure: shadowsocksr/user-config.json ; (ok)"
    read pick
    sudo cp -r shadowsocksr /usr/local

    ssr_svr=shadowsocksr.service
cat << !SSR_SVR! >> $ssr_svr
[Unit]
Description=ShadowsocksR server
After=network.target
Wants=network.target

[Service]
Type=forking
PIDFile=/var/run/shadowsocksr.pid
ExecStart=/usr/bin/python /usr/local/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocksr.pid -c /usr/local/shadowsocksr/user-config.json -d start
ExecStop=/usr/bin/python /usr/local/shadowsocksr/shadowsocks/server.py --pid-file /var/run/shadowsocksr.pid -c /usr/local/shadowsocksr/user-config.json -d stop
ExecReload=/bin/kill -HUP $MAINPID
KillMode=process
Restart=always

[Install]
WantedBy=multi-user.target
!SSR_SVR!
    sudo mv ~/$ssr_svr /etc/systemd/system
    sudo systemctl enable shadowsocksr.service
    sudo systemctl start shadowsocksr.service
    sudo systemctl status shadowsocksr.service
    sudo journalctl -u shadowsocksr
    sudo netstat -tulpn | grep 8388
    sudo tail /var/log/shadowsocksr.log

    echo_msg "make ssr_cli.tar.gz"
    tar -zcf ssr.tar.gz shadowsocksr

elif [ "client" = "$pick" ]; then
    echo_inf "download ssr.tar.gz from server"
    echo_inf "configure usr-configure.json"
    read pick
    tar -zxf ssr.tar.gz
    cd shadowsocksr/shadowsocks
    sudo python local.py -c /etc/shadowsocks.json -d start
    echo_msg "stop client: sudo python local.py -c /etc/shadowsocks.json -d stop"
else
    echo_msg "pick server or client"
fi

echo_msg "https://dcamero.azurewebsites.net/shadowsocksr.html"
echo_msg "https://github.com/erguotou520/electron-ssr/releases"
echo_inf "
======================================================
nodejs http proxy settings:
npm config set proxy http://127.0.0.1:12333
npm config set https-proxy http://127.0.0.1:12333
------------------------------------------------------
Android studio http proxy settings
File->settings->HTTP Proxy->Manual proxy configuration
 - HTTP 
 Host name: 127.0.0.1
 Portnumber: 12333
-------------------------------------------------------
shell http proxy: ~/profile
export http_proxy=127.0.0.1:1233
export https_proxy=127.0.0.1:12333
"
exit 0
