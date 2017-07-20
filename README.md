## Usage:

#### Add new source

    Run add_source.sh, set its url, synctool, localpath, and timeout limit. If you use git, set _initgit to correct value.
    Start running sync.sh for the first time. If you use git, you must set _initgit to '' in config file.
    Run sync.sh and fix problems, until you're sure that the initial pull has succeeded.
    Once the initial pull has succeeded, you must set _initok to 1 in its config file.
    Write sync.sh to crontab. New repo will be published on next automatically sync.
