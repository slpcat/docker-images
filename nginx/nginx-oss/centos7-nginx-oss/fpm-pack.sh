#!/bin/bash

source  /etc/profile.d/rvm.sh

    fpm -f --verbose \
    -n nginx-oss \
    -s dir \
    --iteration 3.el7 \
    -v ${NGINX_VERSION} \
    -t rpm \
    -m nginx-inc \
    --vendor nginx.org \
    -a native \
    -p /root/ \
    -d 'GeoIP,gd,libxslt,libxml2' \
    -C $PKG_ROOT \
    --description 'tengine oss' \
    --conflicts 'tengine,openresty,kong' \
    --url 'http://nginx.org/en' \
    --before-install /before-install.sh \
    --after-install /after-install.sh \
    --after-remove /after-remove.sh \
    --config-files /etc/nginx/nginx.conf
