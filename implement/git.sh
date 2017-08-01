#!/bin/bash

function _usage () {
    cat << EOF

    *****NOTICE: On the first time you sync a git repo, you must pass extra argument 'initrepo'.

    This script is to sync repo by git. I won't do anything that should not be implemented by me.
    Usage: git.sh <git://url> <targetLoaclPath> <timeout> [initrepo]
    Example: ./git.sh 'git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git' /mnt/raid0/linux 4h
    New repo: ./git.sh 'git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable.git' /mnt/raid0/linux 4h initrepo
    
    I'll return 0 on success, return 1 on syntax error, else on general failure.

EOF
}

if [ "$3" == "" ]
then
    _usage
    exit 1
fi

if [ "$4" == "initrepo" ]
then
    mkdir $2 > /dev/null 2>&1
    git clone --mirror $1 $2
fi

cd $2
timeout $3 git remote -v update
retval=$?
cd -

exit $retval