#!/bin/bash

function _usage () {
    cat << EOF

    *****NOTICE: bandersnatch parameter adjustment is not implemented. I'm not sure if it's necessary.

    This script is to sync repo by bandersnatch. I won't do anything that should not be implemented by me.
    Usage: bandersnatch.sh <http(s)://url> <targetLoaclPath> <timeout>
    Example: ./bandersnatch.sh 'https://pypi.python.org' /mnt/raid0/pypi 4h

    I'll return 0 on success, return 1 on syntax error, and return 2 on timeout(failure).

EOF
}

if [ "$3" == "" ]
then
    _usage
    exit 1
fi

echo "
[mirror]
directory = $2
master = $1
timeout = 30
workers = 2
; Note that package index directory hashing is incompatible with pip
hash-index = false
stop-on-error = false
delete-packages = true
;log-config = bandersnatch_log.log

[statistics]
access-log-pattern = /var/log/nginx/*.pypi.python.org*access*
" > /tmp/.bandersnatch_config.conf

timeout $3 bandersnatch -c /tmp/.bandersnatch_config.conf mirror

if [ $? -eq 124 ]
then
    exit 2
else
    ############Something must be done on finishing the first command.
	todoFile=$2/todo
	if [ -f $todoFile ]
	then
		lineCount=`wc -l $todoFile | grep -E '[[:digit:]]+' -o`
		if [ $lineCount -ne 0 ]
		then
            exit 2
		else
            exit 0
		fi
	fi
    ############I'm not sure why I should do it......
    exit 0
fi
