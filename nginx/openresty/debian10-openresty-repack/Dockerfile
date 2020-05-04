FROM slpcat/debian:buster AS builder
MAINTAINER 若虚 <slpcat@qq.com>
#https://nginx.org/en/docs/configure.html
#https://github.com/opentracing-contrib/nginx-opentracing/blob/master/Dockerfile-openresty

RUN \
    apt-get install -y \
        build-essential \
        ca-certificates \
        zlib1g-dev \
        libpcre3 \
        libpcre3-dev \
        libssl-dev \
        autoconf \
        bzip2 \
        gcc \
        libgeoip-dev \
        libgd-dev \
        git \
        wget \
        make \
        libjemalloc-dev \
        liblua5.1-0-dev \
        openssl \
        libcurl4-openssl-dev \
        libz-dev \
        libreadline-dev \
        libxslt-dev \
        libxml2 \
        libxml2-dev \
        curl \
        #protobuf-dev \
        #protobuf-compiler \
        #golang \
        cmake

ENV GO111MODULE=on \
    GOPROXY=https://goproxy.cn

RUN \
     apt-get -y install ruby ruby-dev rubygems-integration \
     && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
     && gem install fpm

COPY *.sh /

RUN \
    bash before-install.sh

ARG RESTY_VERSION=1.15.8.3
ARG NGINX_VERSION=1.15.8
ARG OPENTRACING_CPP_VERSION=v1.5.1
ARG ZIPKIN_CPP_VERSION=v0.5.2
#ARG LIGHTSTEP_VERSION=v0.8.1
ARG JAEGER_CPP_VERSION=v0.4.2
ARG GRPC_VERSION=v1.22.x
#ARG DATADOG_VERSION=v1.1.2
ARG PKG_ROOT=/fpm_install
#ARG CC=/usr/local/bin/gcc
#ARG CXX=/usr/local/bin/g++
ARG CFLAGS="-O2"

RUN \
    mkdir -p /usr/src \
    && cd /usr/src

#Enable requests served by nginx for distributed tracing via The OpenTracing Project.
#https://github.com/opentracing-contrib/nginx-opentracing#building-from-source

### Build opentracing-cpp
RUN \
  cd /usr/src \
  && git clone -b $OPENTRACING_CPP_VERSION https://github.com/opentracing/opentracing-cpp.git \
  && cd opentracing-cpp \
  && mkdir .build && cd .build \
  && cmake -DCMAKE_BUILD_TYPE=Release \
           -DBUILD_TESTING=OFF .. \
  && make \
  && make install \
  && make install DESTDIR=$PKG_ROOT

### Build bridge tracer
ARG LUA_BRIDGE_TRACER_VERSION="937059912311da3b4f45f46cd7d9a2942a248b2d"

RUN \
  cd /usr/src \
  && git clone https://github.com/opentracing/lua-bridge-tracer.git \
  && cd lua-bridge-tracer \
  && git checkout ${LUA_BRIDGE_TRACER_VERSION} \
  && mkdir .build && cd .build \
  && cmake -DCMAKE_BUILD_TYPE=Release \
            .. \
  && make && make install \
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
  && cd $PKG_ROOT/usr/local/lib/ && ln -s libzipkin_opentracing.so libzipkin_opentracing_plugin.so

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
#  && make install \
#  && make install DESTDIR=$PKG_ROOT \
#  && export HUNTER_INSTALL_DIR=$(cat _3rdParty/Hunter/install-root-dir) \
#  && cd $PKG_ROOT/usr/local/lib/ && ln -s libjaegertracing.so libjaegertracing_plugin.so

### Build gRPC
#COPY gpc-$GRPC_VERSION.tar.gz /usr/src/

#RUN \
#  cd "/usr/src" \
#  #&& git clone -b $GRPC_VERSION https://github.com/grpc/grpc \
#  && tar -zxC /usr/src -f /usr/src/gpc-$GRPC_VERSION.tar.gz \
#  && cd grpc-$GRPC_VERSION \
#  #&& git submodule update --init \
#  && make HAS_SYSTEM_PROTOBUF=false && make install \
#  && cd third_party/protobuf \
#  && make install DESTDIR=$PKG_ROOT

### Build nginx-opentracing modules
ENV NGINX_OPENTRACING_VERSION=v0.9.0

RUN \
  cd "/usr/src" \
  && git clone -b $NGINX_OPENTRACING_VERSION https://github.com/opentracing-contrib/nginx-opentracing

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
        #--prefix=/etc/nginx \
        #--sbin-path=/usr/sbin/nginx \
        #--conf-path=/etc/nginx/nginx.conf \
        #--lock-path=/var/lock/nginx.lock \
        #--pid-path=/var/run/nginx.pid \
        #--error-log-path=/var/log/nginx/error.log \
        #--http-log-path=/var/log/nginx/access.log \
        #--http-client-body-temp-path=/var/cache/nginx/client_temp \
        #--http-proxy-temp-path=/var/cache/nginx/proxy_temp \
        #--http-fastcgi-temp-path=/var/cache/nginx/fastcgi_temp \
        #--http-uwsgi-temp-path=/var/cache/nginx/uwsgi_temp \
        #--http-scgi-temp-path=/var/cache/nginx/scgi_temp \
        --with-threads \
        #--with-md5=/usr/include/openssl \
        #--with-pcre=../pcre-$PCRE_VERSION \
        #--with-zlib=../zlib-$ZLIB_VERSION \
        #--with-openssl=../openssl-$OPENSSL_VERSION \
        --with-pcre \
        #--with-zlib \
        #--with-openssl \
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
        #--add-module=/usr/src/nginx-module-sts \
        #--add-module=/usr/src/nginx-module-stream-sts \
        --add-dynamic-module=/usr/src/nginx-opentracing/opentracing \
        #--with-compat \
        --with-luajit \
        #--without-http_redis2_module \
        --with-http_iconv_module \
        #--with-http_postgres_module \
        --with-cc-opt="-I$HUNTER_INSTALL_DIR/include" \
        --with-ld-opt="-L$HUNTER_INSTALL_DIR/lib" \
        --with-ld-opt="-ljemalloc" \
        " 

#Nginx stream server traffic status module
#https://github.com/vozlt/nginx-module-sts
#https://github.com/vozlt/nginx-module-stream-sts

RUN \
    wget "https://openresty.org/download/openresty-${RESTY_VERSION}.tar.gz" -O openresty.tar.gz \
    && tar -zxC /usr/src -f openresty.tar.gz \
    && rm openresty.tar.gz \
    && cd /usr/src \
    && git clone https://github.com/vozlt/nginx-module-vts.git \
    && cd /usr/src/openresty-${RESTY_VERSION} \
    #&& ./configure $CONFIG --with-debug \
    #&& make \
    #&& mv objs/nginx objs/nginx-debug \
    && ./configure $CONFIG \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

#install nginx 
COPY nginx.* /

RUN \
    cd /usr/src/openresty-${RESTY_VERSION} \
    #&& rm -rf /usr/nginx-module-vts/ \
    #&& rm -rf /nginx-upsync-module \
    #&& rm -rf $PKG_ROOT/etc/nginx/html/ \
    #&& mkdir $PKG_ROOT/etc/nginx/conf.d/ \
    #&& mkdir -p $PKG_ROOT/usr/share/nginx/html/ \
    #&& install -m644 html/index.html $PKG_ROOT/usr/share/nginx/html/ \
    #&& install -m644 html/50x.html $PKG_ROOT/usr/share/nginx/html/ \
    #&& install -m755 objs/nginx-debug $PKG_ROOT/usr/sbin/nginx-debug \
    #&& install -m644 -D /nginx.service $PKG_ROOT/usr/lib/systemd/system/nginx.service \
    #&& install -m644 -D /nginx.logrotate $PKG_ROOT/etc/logrotate.d/nginx \
    && mkdir -p $PKG_ROOT/etc/ld.so.conf.d/ && echo "/usr/local/lib" > $PKG_ROOT/etc/ld.so.conf.d/usr-local-x86_64.conf \
    #&& strip $PKG_ROOT/usr/sbin/nginx* \
    && rm -rf /usr/src/openresty-${RESTY_VERSION} 
    # forward request and error logs to docker log collector
    #&& ln -sf /dev/stdout /var/log/nginx/access.log \
    #&& ln -sf /dev/stderr /var/log/nginx/error.log

#luarocks
ARG RESTY_LUAROCKS_VERSION="3.3.1"
COPY luarocks-3.3.1.tar.gz /
RUN \
    export PATH="$PATH:/usr/local/openresty/bin" \
    && cd /usr/src \
    #&& wget https://luarocks.org/releases/luarocks-3.3.1.tar.gz \
    #&& wget https://luarocks.github.io/luarocks/releases/luarocks-3.3.1.tar.gz \
    #&& wget https://github.com/luarocks/luarocks/archive/v3.3.1.tar.gz \
    && tar -zxC /usr/src -f /luarocks-3.3.1.tar.gz \
    && cd luarocks-3.3.1 \
    && ./configure --prefix=/usr/local \
         --lua-suffix=jit \
         --with-lua=/usr/local/openresty/luajit \
         --with-lua-include=/usr/local/openresty/luajit/include/luajit-2.1 \
    && make \
    && make install \
    && make install DESTDIR=$PKG_ROOT

#OpenTracing 
#RUN wget https://github.com/opentracing-contrib/nginx-opentracing/releases/download/$NGINX_OPENTRACING_VERSION/linux-amd64-nginx-$NGINX_VERSION-ngx_http_module.so.tgz \
#  && tar -xzvC $PKG_ROOT/etc/nginx/modules -f linux-amd64-nginx-$NGINX_VERSION-ngx_http_module.so.tgz

# Jaeger
RUN wget https://github.com/jaegertracing/jaeger-client-cpp/releases/download/v0.4.2/libjaegertracing_plugin.linux_amd64.so -O $PKG_ROOT/usr/local/lib/libjaegertracing_plugin.so \
    && chmod +x $PKG_ROOT/usr/local/lib/libjaegertracing_plugin.so

# Zipkin
#RUN wget -O - https://github.com/rnburn/zipkin-cpp-opentracing/releases/download/v0.5.2/linux-amd64-libzipkin_opentracing_plugin.so.gz | gunzip -c > $PKG_ROOT/usr/local/lib/libzipkin_opentracing_plugin.so

RUN \
    fpm -f --verbose \
    -n openresty-repack \ 
    -s dir \
    #--iteration 1.el8 \
    -v "${RESTY_VERSION}" \
    -t deb \
    -m openresty-inc \
    --vendor openresty.org \
    -a native \
    -p /root/ \
    -d 'libjemalloc2,libxml2,libxslt1.1,libgd3' \
    -C $PKG_ROOT \
    --description 'Scalable Web Platform by Extending NGINX with Lua' \
    --conflicts 'nginx,tengine,luarocks,kong' \
    --url 'https://openresty.org/' \
    --before-install /before-install.sh \
    #--after-install /after-install.sh \
    --after-remove /after-remove.sh
    #--config-files /etc/nginx/nginx.conf

FROM slpcat/debian:buster
COPY --from=builder /root/openresty-repack_1.15.8.3_amd64.deb /root
RUN apt install -y libjemalloc2 libxml2 libxslt1.1 libgd3

RUN dpkg -i /root/openresty-repack_1.15.8.3_amd64.deb

#install kong
RUN apt-get install gcc libssl-dev git libyaml-dev unzip

RUN luarocks install kong

#wget kong 
#copy kong config

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
