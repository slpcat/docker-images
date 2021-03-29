FROM quay.io/justcontainers/base-alpine:v0.10.0
MAINTAINER Gorka Lerchundi Osa <glertxundi@gmail.com>

##
## INSTALL
##

# nginx
RUN apk-install ca-certificates nginx=1.8.0-r1

# renderizr
ADD https://github.com/glerchundi/renderizr/releases/download/v0.1.3/renderizr-linux-amd64 /usr/bin/renderizr
RUN chmod 0755 /usr/bin/renderizr

##
## ROOTFS
##

# root filesystem
COPY rootfs /

# s6-fdholderd active by default
RUN s6-rmrf /etc/s6/services/s6-fdholderd/down
