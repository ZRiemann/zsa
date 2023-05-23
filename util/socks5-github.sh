#!/bin/bash

git config --global http.https://github.com.proxy socks5://127.0.0.1:${SSH_SOCKS5_PORT}
