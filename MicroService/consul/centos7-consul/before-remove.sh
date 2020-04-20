#!/bin/bash
/usr/bin/systemctl --no-reload disable consul.service >/dev/null 2>&1 ||:
/usr/bin/systemctl stop consul.service >/dev/null 2>&1 ||:

#/sbin/service consul stop > /dev/null 2>&1
#/sbin/chkconfig --del consul
