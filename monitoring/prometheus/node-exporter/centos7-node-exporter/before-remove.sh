#!/bin/bash
/usr/bin/systemctl --no-reload disable node_exporter.service >/dev/null 2>&1 ||:
/usr/bin/systemctl stop node_exporter.service >/dev/null 2>&1 ||:

#/sbin/service node_exporter stop > /dev/null 2>&1
#/sbin/chkconfig --del node_exporter
