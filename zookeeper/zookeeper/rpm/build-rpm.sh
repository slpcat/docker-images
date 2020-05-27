#!/bin/bash

    fpm -f --verbose \
    -n zookeeper \
    -s dir \
    --iteration 1.el7 \
    -v 3.4.3 \
    -t rpm \
    -m zookeeper \
    --vendor zookeeper.apache.org \
    -a native \
    -p /root/ \
    -C $PKG_ROOT \
    --description 'ZooKeeper is a centralized service for maintaining configuration information, naming, providing distributed synchronization, and providing group services.' \
    --url 'https://zookeeper.apache.org/' \
    #--before-install /before-install.sh 
    #--after-install /after-install.sh \
    #--after-remove /after-remove.sh
    #--config-files /etc/nginx/nginx.conf
