# copy follow lines to ~/.bashrc to enable the environment
# ZSA_ENV=~/git/zsa/env.sh
# if [ -f ${ZSA_ENV} ]; then
#     source ${ZSA_ENV}
# fi

export PATH=$PATH:~/git/zsa/util

# alias
alias gitx='git --no-pager'
# alias python='python3'

# remote settings
# call util/ssh-copy-id.sh to avoid use password
export REMOTE_USER=root
export REMOTE_HOST=1.1.1.1
export REMOTE_NAME=${REMOTE_USER}@${REMOTE_HOST}
export REMOTE_SSH_PORT=22

export SSH_SOCKS5_PORT=9090
