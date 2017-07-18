#!/bin/bash

function _usage () {
    cat << EOF

    This script is to sync repo by lftp. I won't do anything that should not be implemented by me.
    Usage: lftp.sh <http(s)://url> <targetLoaclPath> <timeout>
    Example: ./lftp.sh 'http://repo.msys2.org' /mnt/raid0/msys2 4h

    I'll return 0 on success, return 1 on syntax error, and return 2 on timeout(failure).

EOF
}

if [ "$3" == "" ]
then
    _usage
    exit 1
fi

mkdir $2 > /dev/null 2>&1
cd $2
timeout $3 lftp "$1" -e "mirror --verbose -P 5 --delete; bye"
returnVal=$?
cd -

if [ $returnVal -eq 124 ]
then
    exit 2
else
    exit 0
fi