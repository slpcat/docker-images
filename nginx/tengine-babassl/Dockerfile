FROM slpcat/debian:bullseye AS builder
MAINTAINER 若虚 <slpcat@qq.com>

#https://nginx.org/en/docs/configure.html

RUN \
    apt-get update && apt-get dist-upgrade -y && apt-get install -y git libpcre3 libpcre3-dev zlib1g zlib1g-dev unzip wget cmake build-essential libxslt-dev libgd-dev libjemalloc-dev

COPY *.sh /

RUN \
    bash before-install.sh

ARG PKG_ROOT=/fpm_install
ARG CFLAGS="-O2"


#babassl
RUN \
    mkdir -p /usr/src \
    && cd /usr/src \
    && git clone https://github.com/Tongsuo-Project/Tongsuo.git \
    && mv Tongsuo babassl \
    && cd babassl \
    && git checkout 8.3.1 \
    && mkdir build \
    && cd build \
    && ../config \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

RUN \
    cd /usr/src \
    && git clone https://github.com/alibaba/tengine.git \
    && cd tengine \
    && git checkout 2.3.4 \
    && mv  /tengine-config.sh . \
    && ./tengine-config.sh \
    && make \
    #&& make install \
    && make install DESTDIR=$PKG_ROOT

#install nginx
#COPY nginx.* /

RUN \
    rm -r /fpm_install/var/run/
#    bash -x /fpm-pack.sh

FROM slpcat/debian:bullseye
MAINTAINER 若虚 <slpcat@qq.com>

COPY *.sh /
RUN \
    bash before-install.sh

COPY --from=builder /fpm_install /
RUN apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y libxslt1.1 libxml2 libjemalloc2 libgd3 \
    && ldconfig

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
