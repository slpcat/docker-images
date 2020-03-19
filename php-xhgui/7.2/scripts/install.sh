#!/bin/sh

set -e

# install packages
apt-get update
apt-get install -y rsync git

extensions -i xml mcrypt mongodb

mkdir -p /var/lib/xhgui
chown www-data: /var/lib/xhgui
cd /var/lib/xhgui
gosu www-data git clone https://github.com/perftools/xhgui.git .
gosu www-data /usr/local/lib/composer install
sed -e 's/127\.0\.0\.1/mongo/g' -i config/config.default.php

apt-get purge -y --auto-remove git

apt-get clean -y

