# copy follow lines to ~/.bashrc to enable the environment
# ZSA_ENV=~/git/zsa/env.sh
# if [ -f ${ZSA_ENV} ]; then
#     source ZSA_ENV
# fi

export PATH=$PATH:~/git/zsa/util:~/git/zsi/scripts

# remote settings
# call util/ssh-copy-id.sh to avoid use password
export REMOTE_USER=root
export REMOTE_HOST=45.63.38.17
export REMOTE_NAME=${REMOTE_USER}@${REMOTE_HOST}

