FROM slpcat/centos:7 AS builder
MAINTAINER 若虚 <slpcat@qq.com>
#https://nginx.org/en/docs/configure.html

RUN \
    yum install -y \
        gcc \
        geoip \
        geoip-dev \
        git \
        wget \
        gcc-c++ \
        gd \
        gd-devel \
        make \
        #pcre \
        #pcre-devel \
        #openssl \
        #openssl-devel \
        #openssl11 \
        #openssl11-devel \
        #zlib \
        #zlib-devel \
        libxslt \
        libxslt-devel \
        libxml2 \
        libxml2-devel \
        perl-core \
        rpm-build

RUN \
     yum -y install ruby ruby-devel rubygems \
     && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
     && gem install fpm

COPY *.sh /

RUN \
    bash before-install.sh

ARG NGINX_VERSION=1.17.9
ARG PCRE_VERSION=8.44
ARG ZLIB_VERSION=1.2.11
ARG OPENSSL_VERSION=1.1.1c
ARG OPENTRACING_CPP_VERSION=v1.5.1
ARG ZIPKIN_CPP_VERSION=v0.5.2
#ARG LIGHTSTEP_VERSION=v0.8.1
ARG JAEGER_CPP_VERSION=v0.4.2
ARG GRPC_VERSION=v1.22.x
#ARG DATADOG_VERSION=v1.1.2
ARG PKG_ROOT=/fpm_install
ARG CFLAGS="-O2"
#ARG LDFLAGS="-L /usr/lib64/openssl11/lib"

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
        #--with-md5=/usr/include/openssl \
        --with-pcre=../pcre-$PCRE_VERSION \
        --with-zlib=../zlib-$ZLIB_VERSION \
        --with-openssl=../openssl-$OPENSSL_VERSION \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        --with-sha1-asm \
        --with-md5-asm \
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
        #--with-http_upstream_check_module \
        #--with-http_upstream_consistent_hash_module \
        #--with-http_upstream_ip_hash_module=shared \
        #--with-http_upstream_least_conn_module=shared \
        #--with-http_upstream_session_sticky_module=shared \
        #--with-http_map_module=shared \
        #--with-http_user_agent_module=shared \
        #--with-http_split_clients_module=shared \
        #--with-http_access_module=shared \
        #--with-http_random_index_module \
        #--with-http_secure_link_module \
        #--with-http_auth_request_module \
        --with-ipv6 \
        --with-file-aio \
        #--with-mail \
        #--with-mail_ssl_module \
        --with-pcre \
        --with-pcre-jit \
        #--with-jemalloc \
        --add-module=/usr/src/nginx-module-vts \ 
        #--add-dynamic-module=/usr/src/nginx-opentracing/opentracing \
        "

RUN \
    mkdir -p /usr/src \
    && cd /usr/src

#PCRE – Supports regular expressions. Required by the NGINX Core and Rewrite modules.
#http://linuxfromscratch.org/blfs/view/svn/general/pcre.html
COPY pcre-$PCRE_VERSION.tar.gz /usr/src

RUN \
 #wget https://ftp.pcre.org/pub/pcre/pcre-8.44.tar.gz
 #wget ftp://ftp.csx.cam.ac.uk/pub/software/programming/pcre/pcre-8.44.tar.gz \
 tar -zvxC /usr/src -f /usr/src/pcre-$PCRE_VERSION.tar.gz \
 && cd /usr/src/pcre-$PCRE_VERSION \
 && ./configure --prefix=/usr/local \
                --enable-pcre16                   \
                --enable-pcre32                   \
                --enable-unicode-properties       \
                --enable-jit \
 && make \
 && make install DESTDIR=$PKG_ROOT

#zlib – Supports header compression. Required by the NGINX Gzip module.
COPY zlib-$ZLIB_VERSION.tar.gz /usr/src

RUN \
 #wget http://zlib.net/zlib-1.2.11.tar.gz
 tar -zxC /usr/src -f /usr/src/zlib-$ZLIB_VERSION.tar.gz \
 && cd /usr/src/zlib-$ZLIB_VERSION \
 && ./configure --prefix=/usr/local \
 && make \
 && make install DESTDIR=$PKG_ROOT

#OpenSSL – Supports the HTTPS protocol. Required by the NGINX SSL module and others.
COPY openssl-$OPENSSL_VERSION.tar.gz /usr/src 

RUN \
 #wget http://www.openssl.org/source/openssl-$OPENSSL_VERSION.tar.gz \
 #wget https://ftp.openssl.org/source/old/1.1.1/openssl-$OPENSSL_VERSION.tar.gz \
 tar -zxC /usr/src -f /usr/src/openssl-$OPENSSL_VERSION.tar.gz \
 && cd /usr/src/openssl-$OPENSSL_VERSION \
 && ./config --prefix=/usr/local \
 && make \
 && make install DESTDIR=$PKG_ROOT

#Enable requests served by nginx for distributed tracing via The OpenTracing Project.
#https://github.com/opentracing-contrib/nginx-opentracing#building-from-source

# Jaeger
#wget https://github.com/jaegertracing/jaeger-client-cpp/releases/download/v0.4.2/libjaegertracing_plugin.linux_amd64.so -O /usr/local/lib/libjaegertracing_plugin.so

# LightStep
#wget -O - https://github.com/lightstep/lightstep-tracer-cpp/releases/download/v0.8.1/linux-amd64-liblightstep_tracer_plugin.so.gz | gunzip -c > /usr/local/lib/liblightstep_tracer_plugin.so

# Zipkin
#wget -O - https://github.com/rnburn/zipkin-cpp-opentracing/releases/download/v0.5.2/linux-amd64-libzipkin_opentracing_plugin.so.gz | gunzip -c > /usr/local/lib/libzipkin_opentracing_plugin.so

# Datadog
#wget -O - https://github.com/DataDog/dd-opentracing-cpp/releases/download/v0.3.0/linux-amd64-libdd_opentracing_plugin.so.gz | gunzip -c > /usr/local/lib/libdd_opentracing_plugin.so

#SkyWalking Nginx Agent provides the native tracing capability for Nginx powered by Nginx LUA module. 
#https://github.com/apache/skywalking-nginx-lua

#compile nginx
RUN \
    #wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    wget "http://mirrors.sohu.com/nginx/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && cd /usr/src \
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG --with-debug \
    && make \
    && mv objs/nginx objs/nginx-debug \
    && ./configure $CONFIG \
    && make \
    #&& make install \
    && make install DESTDIR=$PKG_ROOT

#install nginx 
COPY nginx.* /

RUN \
    cd /usr/src/nginx-$NGINX_VERSION \
    #&& rm -rf /usr/nginx-module-vts/ \
    #&& rm -rf /nginx-upsync-module \
    && rm -rf $PKG_ROOT/etc/nginx/html/ \
    && mkdir $PKG_ROOT/etc/nginx/conf.d/ \
    && mkdir -p $PKG_ROOT/usr/share/nginx/html/ \
    && install -m644 html/index.html $PKG_ROOT/usr/share/nginx/html/ \
    && install -m644 html/50x.html $PKG_ROOT/usr/share/nginx/html/ \
    #&& install -m755 objs/nginx-debug $PKG_ROOT/usr/sbin/nginx-debug \
    && install -m644 -D /nginx.service $PKG_ROOT/usr/lib/systemd/system/nginx.service \
    && install -m644 -D /nginx.logrotate $PKG_ROOT/etc/logrotate.d/nginx \
    && strip $PKG_ROOT/usr/sbin/nginx* \
    && rm -rf /usr/src/nginx-$NGINX_VERSION 
    # forward request and error logs to docker log collector
    #&& ln -sf /dev/stdout /var/log/nginx/access.log \
    #&& ln -sf /dev/stderr /var/log/nginx/error.log

RUN \
    fpm -f --verbose \
    -n nginx-oss \ 
    -s dir \
    --iteration 1.el7 \
    -v ${NGINX_VERSION} \
    -t rpm \
    -m nginx-inc \
    --vendor nginx.org \
    -a native \
    -p /root/ \
    -d 'geoip,gd,libxslt,libxml2' \
    -C $PKG_ROOT \
    --description 'nginx oss' \
    #--conflicts 'nginx,tegine.openresty,kong' \
    --url 'http://nginx.org/en' \
    --before-install /before-install.sh \
    --after-install /after-install.sh \
    --after-remove /after-remove.sh \
    --config-files /etc/nginx/nginx.conf

FROM slpcat/centos:7
COPY --from=builder /root/nginx-oss-1.17.9-1.el7.x86_64.rpm /root
RUN yum install -y /root/nginx-oss-1.17.9-1.el7.x86_64.rpm /root

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
