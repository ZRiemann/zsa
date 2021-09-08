#!/bin/bash

echo "ssh -N -D 9090 ${REMOTE_NAME}"
ssh -N -D 9090 ${REMOTE_NAME}

exit 0

# firefox => setting => proxy => Socks5 127.0.0.1 9090
# /usr/bin/google-chrome --user-data-dir="$HOME/proxy-profile" --proxy-server="socks5://localhost:9090"
# "/Applications/Google Chrome.app/Contents/MacOS/Google Chrome" --user-data-dir="$HOME/proxy-profile" --proxy-server="socks5://localhost:9090"
# "C:\Program Files (x86)\Google\Chrome\Application\chrome.exe" --user-data-dir="%USERPROFILE%\proxy-profile"  --proxy-server="socks5://localhost:9090"

# git config --global http.proxy "socks5://127.0.0.1:9090"
# git config --global https.proxy "socks5://127.0.0.1:9090"