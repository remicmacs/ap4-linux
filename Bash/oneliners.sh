#! /bin/env bash

# Number of user processes
ps -U $USER | wc -l

# Test if directory exists and cd in it
[ -d /tmp/1 ] && cd /tmp/1 || echo "/tmp/1 does not exist"

# list all files of filesystem without stderr output
ls -R / 2>/dev/null

# Backup of Home folder in tar.gz archive
tar -czvf /tmp/$USER-$(date +"%Y%m%d").tgz ~