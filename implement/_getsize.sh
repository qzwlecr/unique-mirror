#!/bin/bash
# This script is part of another script, and should NEVER be called by hand, so there's no document.

cd ../config > /dev/null
source $1.conf
du -hd1 $_localpath | awk '/./{line=$0} END{print line}' | cut -f 1
cd - > /dev/null
