#!/bin/bash
# This script is part of another script, and should NEVER be called by hand, so there's no document.

cd ../config > /dev/null
source $1.conf
echo "$_url"
cd - > /dev/null
