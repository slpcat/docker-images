#!/bin/sh
docker pull dockerwest/php:5.6

docker build --no-cache -t dockerwest/php-xhgui:5.6 .
