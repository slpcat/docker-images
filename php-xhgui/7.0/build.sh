#!/bin/sh
docker pull dockerwest/php:7.0

docker build --no-cache -t dockerwest/php-xhgui:7.0 .
