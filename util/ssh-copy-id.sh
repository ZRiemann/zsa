#!/bin/bash

RSA_PUB=~/.ssh/id_rsa.pub
if [ ! -f ${RSA_PUB} ]; then
    echo "${RSA_PUB} not exists generate it"
    ssh-keygen -t rsa
else
    echo "${RSA_PUB} exists"
fi

if [ -z "${REMOTE_NAME}" ]; then
    read -p "Enter <user>@<remote-ip>: " REMOTE_NAME
fi

echo "ssh-copy-id -i ${RSA_PUB} ${REMOTE_NAME}"
ssh-copy-id -i ${RSA_PUB} ${REMOTE_NAME}

exit 0