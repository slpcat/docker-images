#!/bin/bash

groupadd -g 988 nginx
useradd -u 988 -g 988 -M -c "Nginx web server" -d /var/lib/nginx -s /sbin/nologin nginx

if [ ! -d /var/cache/nginx/client_temp ]; then
     mkdir -p /var/cache/nginx/client_temp
fi

if [ ! -d /var/log/nginx ]; then
        mkdir -p /var/log/nginx
fi
 
if [ ! -e /var/log/nginx/access.log ]; then
            touch /var/log/nginx/access.log
            chmod 640 /var/log/nginx/access.log
            chown nginx:nginx /var/log/nginx/access.log
fi

if [ ! -e /var/log/nginx/error.log ]; then
            touch /var/log/nginx/error.log
            chmod 640 /var/log/nginx/error.log
            chown nginx:nginx /var/log/nginx/error.log
fi
