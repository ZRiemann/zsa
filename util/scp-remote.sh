#!/bin/bash

if [ $# = 2 ]; then
    # scp local to remote
    SRC_PATH=$1
    DEST_PATH=${REMOTE_NAME}:$2
else
    # scp remote to .
    SRC_PATH=${REMOTE_NAME}:$1
    DEST_PATH=.
fi

echo "scp ${SRC_PATH} ${DEST_PATH}"
scp -P ${REMOTE_SSH_PORT} -r ${SRC_PATH} ${DEST_PATH}