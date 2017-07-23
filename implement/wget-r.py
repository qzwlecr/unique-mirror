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
        returnStr.append(line[9:endpos])
    print(returnStr)
    return returnStr

def wget(url, localpath):
    # url and localpath must be absolute.
    print('Processing', url)
    subprocess.run(["wget", "-O", localpath, url], stderr=subprocess.PIPE).check_returncode()

def downloadDir(url):
    os.system("mkdir -p " + baselocalpath+url)
    with urllib.request.urlopen(baseurl+url) as f:
        targetArr = responceToList(f.read().decode("utf-8"))
    isdir = lambda t: t[-1] == '/'
    for target in targetArr:
        if isdir(target):
            downloadDir(url + target)
        else:
            wget(baseurl+url+target, baselocalpath+url+target)

downloadDir('')
