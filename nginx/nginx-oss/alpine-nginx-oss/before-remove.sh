#!/bin/bash
/usr/bin/systemctl --no-reload disable nginx.service >/dev/null 2>&1 ||:
/usr/bin/systemctl stop nginx.service >/dev/null 2>&1 ||:

#/sbin/service nginx stop > /dev/null 2>&1
#/sbin/chkconfig --del nginx
#/sbin/chkconfig --del nginx-debug
