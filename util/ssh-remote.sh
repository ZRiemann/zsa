#!/bin/bash

echo "ssh -p ${REMOTE_SSH_PORT} ${REMOTE_NAME}"
ssh -p ${REMOTE_SSH_PORT} ${REMOTE_NAME}
#autossh -M 22220 ${REMOTE_NAME}

exit 0