#!/usr/bin/python3
# Url must be terminated by /

import urllib.request, subprocess
import sys, os

def usage():
    print('''
    Usage:./this.py targetUrl localpath
    Tip: targetUrl and localpath MUST be terminated by "/"
    Example: ./this.py http://mirrors.163.com/linuxmint/packages/ /mnt/raid0/linuxmint/
    ''')
    exit(1)

if len(sys.argv) != 3:
    usage()
baseurl, baselocalpath = sys.argv[1:]

def responceToList(respStr):
    returnStr=[]
    for line in respStr.split('\n'):
        if line.find('<a href="') != 0:
            continue
        endpos = line.find('"',9)
        if endpos == -1:
            continue
        if line[9:endpos] == '..':
            continue
        url=line[9:endpos]

        line=line[::-1]
        endpos = line.find(' ')
        if endpos == -1:
            continue
        size_reversed=line[0:endpos]
        if size_reversed[0] == '\r':
            size_reversed=size_reversed[1:]
        size=int(size_reversed[::-1])

        returnStr.append((url, size))
    print(returnStr)
    return returnStr

def wget(url, localpath, remotesize):
    # url and localpath must be absolute.
    try:
        if os.path.getsize(localpath) == remotesize:
            print('Skip', url, 'at', localpath)
            return
    except OSError:

    print('Processing', url)
    subprocess.run(["wget", "-N", "-O", localpath, url], stderr=subprocess.PIPE).check_returncode()

def downloadDir(url):
    os.system("mkdir -p " + baselocalpath+url)
    with urllib.request.urlopen(baseurl+url) as f:
        targetArr = responceToList(f.read().decode("utf-8"))
    isdir = lambda t: t[-1] == '/'
    for targetTup in targetArr:
        target, size = targetTup
        if isdir(target):
            downloadDir(url + target)
        else:
            wget(baseurl+url+target, baselocalpath+url+target, size)

downloadDir('')
