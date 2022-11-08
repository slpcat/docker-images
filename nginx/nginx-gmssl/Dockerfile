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

#gmcurl
RUN \
    wget https://www.gmssl.cn/gmssl/down/gmcurl \
    && chmod +x gmcurl \
    && mkdir -p $PKG_ROOT/usr/local/bin \
    && mv gmcurl $PKG_ROOT/usr/local/bin

RUN \
    mkdir -p /usr/src \
    && cd /usr/src

#GmSSL
RUN \
    git clone https://github.com/guanzhi/GmSSL.git \
    && cd GmSSL \
    && git checkout v3.0.0 \
    && mkdir build \
    && cd build \
    && cmake .. \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

#compile nginx
ARG CONFIG="\
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
        --with-http_ssl_module \
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
        --with-cc-opt="-I$HUNTER_INSTALL_DIR/include" \
        --with-ld-opt="-L$HUNTER_INSTALL_DIR/lib" \
        --with-ld-opt="-ljemalloc" \
        "

RUN \
    cd /usr/src \
    && git clone https://github.com/zhaoxiaomeng/Nginx-with-GmSSLv3.git \
    && cd Nginx-with-GmSSLv3/ \
    && cp auto/configure . \
    && ./configure $CONFIG \
    && make \
    #&& make install \
    && make install DESTDIR=$PKG_ROOT

#install nginx
#COPY nginx.* /

#RUN \
#    cd /usr/src/nginx-$NGINX_VERSION \
#    #&& rm -rf /usr/nginx-module-vts/ \
#    #&& rm -rf /nginx-upsync-module \
#    && rm -rf $PKG_ROOT/etc/nginx/html/ \
#    && mkdir $PKG_ROOT/etc/nginx/conf.d/ \
#    && mkdir -p $PKG_ROOT/usr/share/nginx/html/ \
#    && install -m644 html/index.html $PKG_ROOT/usr/share/nginx/html/ \
#    && install -m644 html/50x.html $PKG_ROOT/usr/share/nginx/html/ \
#    #&& install -m755 objs/nginx-debug $PKG_ROOT/usr/sbin/nginx-debug \
#    && install -m644 -D /nginx.service $PKG_ROOT/usr/lib/systemd/system/nginx.service \
#    && install -m644 -D /nginx.logrotate $PKG_ROOT/etc/logrotate.d/nginx \
#    && strip $PKG_ROOT/usr/sbin/nginx* \
#    && rm -rf /usr/src/nginx-$NGINX_VERSION
#    # forward request and error logs to docker log collector
#    #&& ln -sf /dev/stdout /var/log/nginx/access.log \
#    #&& ln -sf /dev/stderr /var/log/nginx/error.log

#RUN yum install -y which
#install ruby 2.4
#COPY rvm-installer ruby_install.sh /

#RUN \
#    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
#    #&& curl -sSL https://get.rvm.io | bash -s stable \
#    && bash -x /rvm-installer \
#    && bash -x /ruby_install.sh
#    #&& gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
#    #&& gem install fpm

#COPY fpm-pack.sh /

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
