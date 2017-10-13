#!/bin/bash

function _usage () {
    cat << EOF

    My task is to finish a sync.
    I'll deal with setting locks, downloading files, and setting correct status for web frontend.
    Usage: sync.sh <taskName>
    Example: ./sync.sh linux

    I'll read a configuration file named ./config/$taskName.conf to determine my job.
    Sample config files are located in ./config/examples/*.conf.

    I'll return 4 if configuration file aren't there, or there's a syntax error.
    Return 124 if sync timed out.
    Else if any other error are detected, on which I'll print what happened to stdout.

    ***** Warn: Please run me in my directory. (I'll use cd without ANY check).
                I'll fix it in the future if necessary.

EOF
}

if [ "$1" == "" ]; then
    _usage
    exit 4
fi

if whoami | grep -v '^root$' > /dev/null; then
    echo 'Permission denied.'
    exit 4
fi

if [ ! -f config/$1.conf ]; then
    echo 'Can not find config file.'
    exit 4
fi

source config/$1.conf
_name=$1

if [ $_initok -eq 0 ]; then
    echo 'This is initial pull without timeout limitation.'
    _timeout='30d'
    _msg_syncing='Initing'
    _msg_success='Initing(wait)'
    _msg_failed='Initing(timeout)'
    _msg_error='InitError'
else
    _msg_success='Success'
    _msg_syncing='Syncing'
    _msg_failed='Failed'
    _msg_error='Error'
fi

cd implement
./lockmgr.sh acquire $_name
if [ $? -ne 0 ]
then
    echo 'Another instance is running. Existing...'
    exit 1
fi

./set_status.fish $_name $_msg_syncing

$_pre_sync
_shToUse="$_synctool.sh"
[[ $_custom_sync_cmd == '' ]] && 
    ./$_shToUse $_url $_localpath $_timeout $_initgit ||
    timeout $_timeout $_custom_sync_cmd
_ret=$?
$_post_sync

if [ $_ret -eq 0 ]; then
    echo 'Succeeded.'
    ./set_status.fish $_name $_msg_success
elif [ $_ret -eq 124 ]; then
    echo 'Sync failed because of timing out.'
    ./set_status.fish $_name $_msg_failed
else
    echo 'Sync failed on unknown error '"($_ret)."
    ./set_status.fish $_name "$_msg_error($_ret)"
fi

./lockmgr.sh release $_name
cd ..

echo 'Done.'
exit $_ret
