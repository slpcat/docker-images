#!/bin/sh
# for busybox sh, which is dash

LOG=$1
DEFAULT_SIZE=$(expr 100 \* 1024 \* 1024)
SIZE=${2:-${DEFAULT_SIZE}}

/usr/bin/tail -F $1 &

while true ; do
    sleep 30
    if [ $(/bin/stat -c%s $LOG) -gt $SIZE ] ; then
        mv $LOG $LOG.1
    fi
done
