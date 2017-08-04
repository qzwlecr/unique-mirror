#!/bin/bash

function _usage () {
    cat << EOF

    One-key add source.
    Usage: ./add_source.sh <attrName>
    I'll call vim to help you finish config file.

    I'll return 0 on success, else on error.

EOF
}

if [ "$1" == "" ]; then
    _usage
    exit 1
fi

if whoami | grep -v '^root$' > /dev/null; then
    echo 'Permission denied.'
    exit 4
fi

_samp='./config/examples/samp.conf' 
_cfg="./config/$1.conf"

if [ ! -f $_samp ]; then
    echo "$_samp not exists."
    exit 2
fi

if [ -f $_cfg ]; then
    echo "$_cfg already exists."
    exit 2
fi

mkdir /mnt/raid0/$1
ln -s /mnt/raid0/$1 /home/www/mirrors/$1
cp $_samp $_cfg
vim $_cfg

cat "Disallow: /$1" >> /home/www/mirrors/robots.txt

echo 'Done.'
