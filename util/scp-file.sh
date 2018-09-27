#!/bin/bash

echo "sync webrtc.mdj from/to remote"

remote=192.168.10.248
user=user
passwd=passwd
fname=file.txt
fpath=/home/user

echo "Is fetch? (yes|no)"
read pick
if [ "no" = "${pick}" ]; then
	echo "Push to remote: ${user}@${remote}:${fpath}/${fname}"
	sshpass -p ${passwd} scp ${fname} ${user}@${remote}:${fpath}
else
    echo "Fetch from remote: ${user}@${remote}:${fpath}/${fname}"
	sshpass -p ${passwd} scp ${user}@${remote}:${fpath}/${fname} .
fi

exit 0
