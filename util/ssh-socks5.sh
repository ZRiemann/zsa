#!/bin/bash

echo "ssh -N -D 0.0.0.0:${SSH_SOCKS5_PORT} -p ${REMOTE_SSH_PORT} ${REMOTE_NAME}"
ssh -N -D 0.0.0.0:${SSH_SOCKS5_PORT} -p ${REMOTE_SSH_PORT} ${REMOTE_NAME}

exit 0

# firefox => setting => proxy => Socks5 + 127.0.0.1 + ${SSH_SOCKS5_PORT} + Proxy DNS when using SOCKS5
# /usr/bin/google-chrome --user-data-dir="$HOME/proxy-profile" --proxy-server="socks5://localhost:${SSH_SOCKS5_PORT}"
# "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --user-data-dir="$HOME/proxy-profile" --proxy-server="socks5://localhost:${SSH_SOCKS5_PORT}"
# "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --user-data-dir="%USERPROFILE%\proxy-profile"  --proxy-server="socks5://localhost:${SSH_SOCKS5_PORT}"

# git config --global http.https://github.com.proxy socks5://127.0.0.1:${SSH_SOCKS5_PORT}
# git config --global --unset http.https://github.com.proxy
