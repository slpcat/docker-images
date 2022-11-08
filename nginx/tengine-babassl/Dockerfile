FROM slpcat/debian:bullseye AS builder
MAINTAINER 若虚 <slpcat@qq.com>

#https://nginx.org/en/docs/configure.html

RUN \
    apt-get update && apt-get install -y git libpcre3 libpcre3-dev zlib1g zlib1g-dev unzip wget cmake build-essential libxslt-dev libgd-dev libjemalloc-dev

COPY *.sh /

RUN \
    bash before-install.sh

ARG PKG_ROOT=/fpm_install
ARG CFLAGS="-O2"


#babassl
RUN \
    mkdir -p /usr/src \
    && cd /usr/src

RUN \
    git clone https://github.com/Tongsuo-Project/Tongsuo.git \
    && cd Tongsuo \
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
    && ./configure \
        --user=nginx \
        --group=nginx \
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --conf-path=/etc/nginx/nginx.conf \
        --lock-path=/var/lock/nginx.lock \
        --pid-path=/var/run/nginx.pid \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-threads \
        --without-http_upstream_zone_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --with-http_auth_request_module \
        --with-http_image_filter_module \
        --with-http_addition_module \
        --with-http_dav_module \
        --with-http_realip_module \
        --with-http_v2_module \
        --with-http_stub_status_module \
        --with-http_sub_module \
        --with-http_xslt_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_degradation_module \
        --with-file-aio \
        --with-pcre \
        --with-pcre-jit \
        --add-module=modules/ngx_openssl_ntls \
        --with-openssl=/usr/src/Tongsuo \
        --with-openssl-opt="--strict-warnings enable-ntls" \
        --with-http_ssl_module --with-stream \
        --with-stream_ssl_module --with-stream_sni \
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
