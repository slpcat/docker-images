FROM slpcat/gcc:v9.3.0-centos7 AS builder
MAINTAINER 若虚 <slpcat@qq.com>
#https://nginx.org/en/docs/configure.html

RUN \
    yum install -y \
        autogen \
        autoconf \
        bzip2 \
        #gcc \
        GeoIP \
        GeoIP-devel \
        git \
        wget \
        #gcc-c++ \
        gd \
        gd-devel \
        make \
        #pcre \
        #pcre-devel \
        #openssl \
        openssl-devel \
        #openssl11 \
        #openssl11-devel \
        #zlib \
        #zlib-devel \
        which \
        libxslt \
        libxslt-devel \
        libxml2 \
        libxml2-devel \
        perl-core \
        rpm-build \
        #libcurl-devel \
        #protobuf-devel \
        #protobuf-compiler \
        #golang \
        cmake3

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn

RUN ln -s /usr/bin/cmake3 /usr/bin/cmake 

COPY *.sh /

RUN \
    bash before-install.sh

ARG NGINX_VERSION=1.17.3
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
 && make install DESTDIR=$PKG_ROOT \
 && ldconfig

#curl
ARG CURL_VERSION=7.69.1
COPY curl-$CURL_VERSION.tar.gz /

#https://github.com/curl/curl/releases/download/curl-7_69_1/curl-7.69.1.tar.gz
RUN \
    cd /usr/src \
    && tar -zxC /usr/src -f /curl-$CURL_VERSION.tar.gz \
    && cd /usr/src/curl-$CURL_VERSION \
    && ./configure --prefix=/usr/local --with-ssl \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

#Enable requests served by nginx for distributed tracing via The OpenTracing Project.
#https://github.com/opentracing-contrib/nginx-opentracing#building-from-source

### Build opentracing-cpp
RUN \
  cd /usr/src \
  && git clone -b $OPENTRACING_CPP_VERSION https://github.com/opentracing/opentracing-cpp.git \
  && cd opentracing-cpp \
  && mkdir .build && cd .build \
  && cmake -DCMAKE_BUILD_TYPE=Release \
           -DBUILD_TESTING=ON .. \
  && make \
  && make install \
  && make install DESTDIR=$PKG_ROOT

### Build zipkin-cpp-opentracing
RUN \
  cd /usr/src \
  && git clone -b $ZIPKIN_CPP_VERSION https://github.com/rnburn/zipkin-cpp-opentracing.git \
  && cd zipkin-cpp-opentracing \
  && mkdir .build && cd .build \
  && cmake -DBUILD_SHARED_LIBS=1 -DCMAKE_BUILD_TYPE=Release -DBUILD_TESTING=OFF .. \
  && make \
  && make install \
  && make install DESTDIR=$PKG_ROOT \
  && cd $PKG_ROOT/usr/local/lib/ \
  && ln -s libzipkin_opentracing.so libzipkin_opentracing_plugin.so 

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

COPY usr-local-lib.conf /etc/ld.so.conf.d/
RUN mkdir -p $PKG_ROOT/etc/ld.so.conf.d/
COPY usr-local-lib.conf $PKG_ROOT/etc/ld.so.conf.d/

RUN ldconfig \
    && ldconfig -p \
    && ln -sf /usr/local/lib64/libstdc++.so.6 /lib64/libstdc++.so.6

ENV TENGINE_VERSION 2.3.2

# nginx: https://git.io/vSIyj


ENV CONFIG "\
        --prefix=/etc/nginx \
        --sbin-path=/usr/sbin/nginx \
        --modules-path=/usr/lib/nginx/modules \
        --conf-path=/etc/nginx/nginx.conf \
        --error-log-path=/var/log/nginx/error.log \
        --http-log-path=/var/log/nginx/access.log \
        --pid-path=/var/run/nginx.pid \
        --lock-path=/var/run/nginx.lock \
        --http-client-body-temp-path=/var/cache/nginx/client_temp \
        --http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        --http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        --http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        --http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --user=nginx \
        --group=nginx \
        --with-http_ssl_module \
        --with-http_v2_module \
        --with-http_realip_module \
        --with-http_addition_module \
        --with-http_sub_module \
        --with-http_dav_module \
        --with-http_flv_module \
        --with-http_mp4_module \
        --with-http_gunzip_module \
        --with-http_gzip_static_module \
        --with-http_random_index_module \
        --with-http_secure_link_module \
        --with-http_stub_status_module \
        --with-http_auth_request_module \
        --with-http_xslt_module=dynamic \
        --with-http_image_filter_module=dynamic \
        --with-http_slice_module \
        --with-http_geoip_module=dynamic \
        --with-threads \
        --with-stream \
        --with-stream_ssl_module \
        --with-stream_ssl_preread_module \
        --with-stream_realip_module \
        --with-stream_geoip_module=dynamic \
        --with-http_slice_module \
        --with-mail \
        --with-mail_ssl_module \
        --with-compat \
        --with-file-aio \
        --with-pcre=../pcre-$PCRE_VERSION \
        --with-pcre-jit \
        --with-zlib=../zlib-$ZLIB_VERSION \
        --with-openssl=../openssl-$OPENSSL_VERSION \
        --add-module=modules/nginx-module-vts \
        --add-module=modules/nginx-opentracing/opentracing \ 
        --add-module=modules/ngx_http_upstream_check_module \
        --add-module=modules/headers-more-nginx-module-0.33 \
        --add-module=modules/ngx_cache_purge-2.3 \
        --add-module=modules/ngx_slowfs_cache-1.10 \
	--add-module=modules/ngx_http_upstream_session_sticky_module \
        "
COPY  ngx_cache_purge-2.3.tar.gz ngx_slowfs_cache-1.10.tar.gz /tmp/

RUN     \
        curl -L "https://github.com/alibaba/tengine/archive/$TENGINE_VERSION.tar.gz" -o tengine.tar.gz \
        && mkdir -p /usr/src \
        && tar -zxC /usr/src -f tengine.tar.gz \
        && rm tengine.tar.gz \
        && cd /usr/src/tengine-$TENGINE_VERSION/modules \
        && git clone https://github.com/vozlt/nginx-module-vts.git \
        && git clone https://github.com/opentracing-contrib/nginx-opentracing.git \
        && cd /usr/src/tengine-$TENGINE_VERSION \
        && curl -L "https://github.com/openresty/headers-more-nginx-module/archive/v0.33.tar.gz" -o more.tar.gz \
        && tar -zxC /usr/src/tengine-$TENGINE_VERSION/modules -f more.tar.gz \
	&& rm  more.tar.gz \
        && tar -zxC /usr/src/tengine-$TENGINE_VERSION/modules -f /tmp/ngx_cache_purge-2.3.tar.gz \
        && tar -zxC /usr/src/tengine-$TENGINE_VERSION/modules -f /tmp/ngx_slowfs_cache-1.10.tar.gz \
	&& ls -l /usr/src/tengine-$TENGINE_VERSION/modules \
        && ./configure $CONFIG \
        && make \
        #&& make install \
        && make install DESTDIR=$PKG_ROOT

#install nginx
COPY nginx.* /

RUN \
    cd /usr/src/tengine-$TENGINE_VERSION \
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
    && rm -rf /usr/src/tengine-$TENGINE_VERSION
    # forward request and error logs to docker log collector
    #&& ln -sf /dev/stdout /var/log/nginx/access.log \
    #&& ln -sf /dev/stderr /var/log/nginx/error.log

#ngx_http_module
#RUN wget https://github.com/opentracing-contrib/nginx-opentracing/releases/download/v0.9.0/linux-amd64-nginx-$NGINX_VERSION-ngx_http_module.so.tgz \
#   && tar -zxf linux-amd64-nginx-$NGINX_VERSION-ngx_http_module.so.tgz -C $PKG_ROOT/usr/lib/nginx/modules/

# Jaeger
RUN \
    wget https://github.com/jaegertracing/jaeger-client-cpp/releases/download/v0.4.2/libjaegertracing_plugin.linux_amd64.so -O $PKG_ROOT/usr/local/lib/libjaegertracing_plugin.so \
    && chmod +x $PKG_ROOT/usr/local/lib/libjaegertracing_plugin.so

# Zipkin
#RUN wget -O - https://github.com/rnburn/zipkin-cpp-opentracing/releases/download/v0.5.2/linux-amd64-libzipkin_opentracing_plugin.so.gz | gunzip -c > $PKG_ROOT/usr/local/lib/libzipkin_opentracing_plugin.so


#install ruby 2.4
COPY rvm-installer ruby_install.sh /

RUN \
    gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB \
    #&& curl -sSL https://get.rvm.io | bash -s stable \
    && bash -x /rvm-installer \
    && bash -x /ruby_install.sh
    #&& gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
    #&& gem install fpm

COPY fpm-pack.sh /

RUN \
    bash -x /fpm-pack.sh 

FROM slpcat/centos:7
COPY --from=builder /root/tengine-oss-2.3.2-5.el7.x86_64.rpm /root
RUN yum install -y /root/tengine-oss-2.3.2-5.el7.x86_64.rpm

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
