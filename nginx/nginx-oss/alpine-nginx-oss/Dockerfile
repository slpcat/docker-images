#FROM slpcat/centos:7 AS builder
FROM alpine:3.11
MAINTAINER 若虚 <slpcat@qq.com>
#https://nginx.org/en/docs/configure.html

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/' /etc/apk/repositories

RUN \
    apk add --no-cache --virtual .build-deps \
                bash \
                tzdata \
                vim \
                tini \
                su-exec \
                gzip \
                tar \
                wget \
                curl \
                gcc \
                libc-dev \
                make \
                openssl-dev \
                pcre-dev \
                zlib-dev \
                linux-headers \
                curl \
                gnupg \
                libxslt-dev \
                gd-dev \
                geoip-dev

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn

#RUN ln -s /usr/bin/cmake3 /usr/bin/cmake \
#    && ln -sf /usr/bin/cc /usr/local/bin/gcc

RUN \
     apk add ruby ruby-dev \
     #&& gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
     && gem install fpm

COPY *.sh /

RUN \
    bash before-install.sh

ARG NGINX_VERSION=1.17.9
ARG JEMALLOC_VERSION=5.2.1
ARG PCRE_VERSION=8.44
ARG ZLIB_VERSION=1.2.11
ARG OPENSSL_VERSION=1.1.1g
ARG OPENTRACING_CPP_VERSION=v1.5.1
ARG ZIPKIN_CPP_VERSION=v0.5.2
#ARG LIGHTSTEP_VERSION=v0.8.1
ARG JAEGER_CPP_VERSION=v0.4.2
ARG GRPC_VERSION=v1.22.x
#ARG DATADOG_VERSION=v1.1.2
ARG PKG_ROOT=/fpm_install
ARG CC=/usr/local/bin/gcc
ARG CXX=/usr/local/bin/g++
ARG CFLAGS="-O2"
#ARG LDFLAGS="-L /usr/lib64/openssl11/lib"

RUN \
    mkdir -p /usr/src \
    && cd /usr/src

#jemalloc is a general purpose malloc(3) implementation that emphasizes
#fragmentation avoidance and scalable concurrency support.  
#COPY jemalloc-$JEMALLOC_VERSION.tar.bz2 /

#RUN \
    #wget https://github.com/jemalloc/jemalloc/releases/download/$JEMALLOC_VERSION/jemalloc-$JEMALLOC_VERSION.tar.bz2 \
#    tar -jxvC /usr/src -f /jemalloc-$JEMALLOC_VERSION.tar.bz2 \
#    && cd /usr/src/jemalloc-$JEMALLOC_VERSION \
#    && ./autogen.sh \
#    && make -j2 \
#    && make install \
#    && make install  DESTDIR=$PKG_ROOT

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

#curl
ARG CURL_VERSION=7.69.1
COPY curl-$CURL_VERSION.tar.gz /

#https://github.com/curl/curl/releases/download/curl-7_69_1/curl-7.69.1.tar.gz
RUN \
    cd /usr/src \
    && tar -zxC /usr/src -f /curl-$CURL_VERSION.tar.gz \
    && cd /usr/src/curl-$CURL_VERSION \
    && ./configure --prefix=/usr/local \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

#Enable requests served by nginx for distributed tracing via The OpenTracing Project.
#https://github.com/opentracing-contrib/nginx-opentracing#building-from-source

### Build opentracing-cpp
#RUN \
#  cd /usr/src \
#  && git clone -b $OPENTRACING_CPP_VERSION https://github.com/opentracing/opentracing-cpp.git \
#  && cd opentracing-cpp \
#  && mkdir .build && cd .build \
#  && cmake -DCMAKE_BUILD_TYPE=Release \
#           -DBUILD_TESTING=OFF .. \
#  && make \
#  && make install \
#  && make install DESTDIR=$PKG_ROOT

### Build zipkin-cpp-opentracing
#RUN \
#  cd /usr/src \
#  && git clone -b $ZIPKIN_CPP_VERSION https://github.com/rnburn/zipkin-cpp-opentracing.git \
#  && cd zipkin-cpp-opentracing \
#  && mkdir .build && cd .build \
#  && cmake -DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF .. \
#  && make \
#  && make install \
#  && make install DESTDIR=$PKG_ROOT \
#  && cd $PKG_ROOT/usr/local/lib/ && ln -s libzipkin_opentracing.so libzipkin_opentracing_plugin.so

### Build Jaeger cpp-client
#RUN \
#  cd /usr/src \
#  && git clone -b $JAEGER_CPP_VERSION https://github.com/jaegertracing/cpp-client.git jaeger-cpp-client \
#  && cd jaeger-cpp-client \
#  && mkdir .build && cd .build \
#  && cmake -DCMAKE_BUILD_TYPE=Release \
#           -DBUILD_TESTING=OFF \
#           -DJAEGERTRACING_WITH_YAML_CPP=ON .. \
#  && make \
#  && make install DESTDIR=$PKG_ROOT \
#  && export HUNTER_INSTALL_DIR=$(cat _3rdParty/Hunter/install-root-dir) \
#  && cd $PKG_ROOT/usr/local/lib/ && ln -s libjaegertracing.so libjaegertracing_plugin.so

### Build gRPC
#COPY gpc-$GRPC_VERSION.tar.gz /usr/src/

#RUN \
#  cd "/usr/src" \
  #&& git clone -b $GRPC_VERSION https://github.com/grpc/grpc \
#  && tar -zxC /usr/src -f /usr/src/gpc-$GRPC_VERSION.tar.gz \
#  && cd grpc-$GRPC_VERSION \
  #&& git submodule update --init \
#  && make HAS_SYSTEM_PROTOBUF=false && make install \
#  && cd third_party/protobuf \
#  && make install DESTDIR=$PKG_ROOT

### Build nginx-opentracing modules
ENV NGINX_OPENTRACING_VERSION=v0.9.0

#RUN \
#  cd "/usr/src" \
#  && git clone -b $NGINX_OPENTRACING_VERSION https://github.com/opentracing-contrib/nginx-opentracing

  #&& NGINX_VERSION=`nginx -v 2>&1` && NGINX_VERSION=${NGINX_VERSION#*nginx/} \
  #&& echo "deb-src http://nginx.org/packages/mainline/debian/ stretch nginx" >> /etc/apt/sources.list \
  #&& apt-get update \
  #&& apt-get build-dep -y nginx \
  #&& wget -O nginx-release-${NGINX_VERSION}.tar.gz https://github.com/nginx/nginx/archive/release-${NGINX_VERSION}.tar.gz \
  #&& tar zxf nginx-release-${NGINX_VERSION}.tar.gz \
  #&& auto/configure \

  #      --with-compat \
  #      --add-dynamic-module=/src/opentracing \
  #      --with-cc-opt="-I$HUNTER_INSTALL_DIR/include" \
  #      --with-ld-opt="-L$HUNTER_INSTALL_DIR/lib" \
  #      --with-debug \
  #&& make modules \
  #&& cp objs/ngx_http_opentracing_module.so $NGINX_MODULES_PATH/ \
	# if we have leftovers from building, let's purge them (including extra, unnecessary build deps)


#SkyWalking Nginx Agent provides the native tracing capability for Nginx powered by Nginx LUA module. 
#https://github.com/apache/skywalking-nginx-lua

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
        #--with-md5=/usr/include/openssl \
        --with-pcre=../pcre-$PCRE_VERSION \
        --with-zlib=../zlib-$ZLIB_VERSION \
        --with-openssl=../openssl-$OPENSSL_VERSION \
        --with-http_ssl_module \
        --with-http_gzip_static_module \
        --with-http_gunzip_module \
        #--with-sha1-asm \
        #--with-md5-asm \
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
        #--with-ipv6 \
        --with-file-aio \
        #--with-mail \
        #--with-mail_ssl_module \
        --with-pcre \
        --with-pcre-jit \
        #--with-jemalloc \
        --add-module=/usr/src/nginx-module-vts \
        #--add-dynamic-module=/usr/src/nginx-opentracing/opentracing \
        #--with-compat \
        --with-cc-opt="-I$HUNTER_INSTALL_DIR/include" \
        --with-ld-opt="-L$HUNTER_INSTALL_DIR/lib" \
        #--with-ld-opt="-ljemalloc" \
        " 
RUN \
    #wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    wget "http://mirrors.sohu.com/nginx/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && cd /usr/src \
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    #&& git clone https://github.com/Refinitiv/nginx-sticky-module-ng.git \
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
    && rm -rf /usr/src/nginx-$NGINX_VERSION \
    # forward request and error logs to docker log collector
    #&& ln -sf /dev/stdout /var/log/nginx/access.log \
    #&& ln -sf /dev/stderr /var/log/nginx/error.log
    && apk add --no-cache --virtual .nginx-rundeps $runDeps \
    && apk del .build-deps 

# Jaeger
RUN wget https://github.com/jaegertracing/jaeger-client-cpp/releases/download/v0.4.2/libjaegertracing_plugin.linux_amd64.so -O $PKG_ROOT/usr/local/lib/libjaegertracing_plugin.so

# Zipkin
RUN wget -O - https://github.com/rnburn/zipkin-cpp-opentracing/releases/download/v0.5.2/linux-amd64-libzipkin_opentracing_plugin.so.gz | gunzip -c > $PKG_ROOT/usr/local/lib/libzipkin_opentracing_plugin.so

RUN \
    fpm -f --verbose \
    -n nginx-oss \ 
    -s dir \
    --iteration 2.el7 \
    -v ${NGINX_VERSION} \
    -t apk \
    -m nginx-inc \
    --vendor nginx.org \
    -a native \
    -p /root/ \
    -d 'geoip,gd,libxslt,libxml2' \
    -C $PKG_ROOT \
    --description 'nginx oss' \
    #--conflicts 'nginx,tegine,openresty,kong' \
    --url 'http://nginx.org/en' \
    --before-install /before-install.sh \
    --after-install /after-install.sh \
    --after-remove /after-remove.sh \
    --config-files /etc/nginx/nginx.conf

FROM slpcat/centos:7
COPY --from=builder /root/nginx-oss-1.17.9-2.el7.x86_64.rpm /root
RUN yum install -y /root/nginx-oss-1.17.9-2.el7.x86_64.rpm 

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
