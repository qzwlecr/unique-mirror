#!/bin/bash

function _usage () {
    cat << EOF

    This script is to sync repo by wget. I won't do anything that should not be implemented by me.
    Warning: repo must have NO index.html.
    Usage: wget.sh <http(s)://url> <targetLoaclPath> <timeout>
    Example: ./wget.sh 'https://mirrors.tuna.tsinghua.edu.cn/archlinux/' '/mnt/raid0/archlinux' 4h

    I'll return 0 on success, return 1 on syntax error, else on generic failure.

EOF
}

if [ "$3" == "" ]
then
    _usage
    exit 1
fi

function getlast() {
    str=$1
    i=$((${#str}-1))
    echo ${str:$i:1}
}
function fixlastchar () {
    _last=`getlast $1`
    if [ "$_last" == "/" ]; then
        echo $1
    else
        echo $1/
    fi
}
_local=`fixlastchar $2`
_url=`fixlastchar $1`

mkdir $2 > /dev/null 2>&1
timeout $3 ./wget-r.py $_url $_local

exit $?
