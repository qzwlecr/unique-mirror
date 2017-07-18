#!/bin/bash

function _usage () {
    cat << EOF

    I'm to manage the lock.
    Usage: lockmgr.sh <acquire/status/release> <lockId>

    You can give any string as lockId, which fits this regex: ^[0-9a-zA-Z_-]+$
    If given lockId doesn't exist, I believe the lock is free.

    acquire will return 0 on success, return 1 on syntax error(I'll do nothing on this case), return 3 if the lock's already occupied.
    status will return 0 if the lock's free, return 3 if occupied, return 1 on syntax error.
    release will return 0 on success, return 1 on syntax error(I'll do nothing on this case), return 3 if the lock's already free.

EOF
}

if [ "$2" == "" ]; then
    _usage
    exit 1
fi

if [ ! -f /tmp/.lockmgr.dat ]; then
    touch /tmp/.lockmgr.dat
fi

function _isfree () {
    if grep "^$1"'$' /tmp/.lockmgr.dat > /dev/null; then
        return 1 # It's free
    else
        return 0 # It's not free
    fi 
}

function _makefree () {
    grep -v "^$1"'$' /tmp/.lockmgr.dat > /tmp/.lockmgr.dat.tmp
    mv /tmp/.lockmgr.dat.tmp /tmp/.lockmgr.dat
}

function _nofree () {
    echo "$1" >> /tmp/.lockmgr.dat
}

case "$1" in
    "status")
        if _isfree $2; then
            exit 0
        else
            exit 3
        fi
        ;;
    "acquire")
        if _isfree $2; then
            _nofree $2
            exit 0
        else
            exit 3
        fi
        ;;
    "release")
        if _isfree $2; then
            exit 3
        else
            _makefree $2
            exit 0
        fi
        ;;
    *)
        exit 1
esac

