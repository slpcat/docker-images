#!/bin/sh

/prepare.sh

# dont count on the DEVELOPMENT flag
mkdir -p /xhprof
chown www-data:www-data /xhprof

gosu www-data rsync -a --info=progress2 /var/lib/xhgui/ /phpapp/

if [ "php-fpm5.6" != "$1" ] && [ "/bin/bash" != "$1" ]; then
    exec gosu www-data "$@"
else
    exec "$@"
fi
