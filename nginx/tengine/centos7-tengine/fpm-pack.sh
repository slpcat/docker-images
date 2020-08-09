#!/bin/bash

source  /etc/profile.d/rvm.sh

    fpm -f --verbose \
    -n tengine-oss \
    -s dir \
    --iteration 5.el7 \
    -v ${TENGINE_VERSION} \
    -t rpm \
    -m tengine-inc \
    --vendor tengine.org \
    -a native \
    -p /root/ \
    -d 'GeoIP,gd,libxslt,libxml2' \
    -C $PKG_ROOT \
    --description 'tengine oss' \
    --conflicts 'nginx,openresty,kong' \
    --url 'http://nginx.org/en' \
    --before-install /before-install.sh \
    --after-install /after-install.sh \
    --after-remove /after-remove.sh \
    --config-files /etc/nginx/nginx.conf
