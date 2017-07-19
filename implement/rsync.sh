#!/bin/bash

function _usage () {
    cat << EOF

    This script is to sync repo by rsync. I won't do anything that should not be implemented by me.
    Usage: rsync.sh <rsync://url> <targetLoaclPath> <timeout>
    Example: ./rsync.sh 'rsync://mirrors.tuna.tsinghua.edu.cn/archlinux/' /mnt/raid0/archlinux 4h

    I'll return 0 on success, return 1 on syntax error, and return 2 on timeout(failure).

EOF
}

if [ "$3" == "" ]
then
    _usage
    exit 1
fi

mkdir $2 > /dev/null 2>&1
timeout $3 rsync --size-only --verbose --recursive --update --links --hard-links --safe-links --perms --times --delete-after --progress --human-readable $1 $2

if [ $? -eq 124 ]
then
    exit 2
else
    exit 0
fi
