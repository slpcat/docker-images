FROM slpcat/debian:bookworm AS builder
MAINTAINER 若虚 <slpcat@qq.com>

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y  wget curl vim \
        bzip2 \
        gcc \
        libgeoip-dev \
        git \
        wget \
        zlib1g-dev libpcre3-dev libssl-dev \
        libgd-dev \
        make \
        libxslt-dev \
        libjemalloc-dev \
        libpcre2-dev \
        openssl \
        libssl-dev \
        zlib1g-dev \
        libxml2-dev \
        curl \
        build-essential autoconf automake libtool gawk alien fakeroot \
        cmake

ARG NGINX_VERSION=1.26.0
#ARG JEMALLOC_VERSION=5.2.1
#ARG PCRE_VERSION=8.44
#ARG ZLIB_VERSION=1.2.11
ARG OPENSSL_VERSION=3.3.0
#ARG OPENTRACING_CPP_VERSION=v1.5.1
#ARG ZIPKIN_CPP_VERSION=v0.5.2
#ARG LIGHTSTEP_VERSION=v0.8.1
#ARG JAEGER_CPP_VERSION=v0.4.2
#ARG GRPC_VERSION=v1.22.x
#ARG DATADOG_VERSION=v1.1.2
ARG PKG_ROOT=/fpm_install
#ARG CC=/usr/local/bin/gcc
#ARG CXX=/usr/local/bin/g++
#ARG CFLAGS="-O2"
#ARG LDFLAGS="-L /usr/lib64/openssl11/lib"

RUN \
    mkdir -p /usr/src \
    && cd /usr/src

#compile nginx
ARG CONFIG='\
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
        #--with-pcre=../pcre-$PCRE_VERSION \
        #--with-zlib=../zlib-$ZLIB_VERSION \
        #--with-openssl=../openssl-$OPENSSL_VERSION \
        --with-openssl=../openssl-3.3.0 \
        --with-openssl-opt=enable-ktls \
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
        #--add-module=/usr/src/nginx-module-vts \
        #--add-module=/usr/src/nginx-module-sts \
        #--add-module=/usr/src/nginx-module-stream-sts \
        #--add-dynamic-module=/usr/src/nginx-opentracing/opentracing \
        --with-compat \
        #--with-ld-opt="-Wl,-Bsymbolic-functions" \
        '

RUN \
    cd /usr/src \
    && wget "https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz" \
    && tar xzf openssl-${OPENSSL_VERSION}.tar.gz \
    #wget "http://nginx.org/download/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && wget "http://mirrors.sohu.com/nginx/nginx-${NGINX_VERSION}.tar.gz" -O nginx.tar.gz \
    && tar -zxC /usr/src -f nginx.tar.gz \
    && rm nginx.tar.gz \
    && cd /usr/src/nginx-$NGINX_VERSION \
    && ./configure $CONFIG \
    && make -j4 \
    #&& make install \
    && make install DESTDIR=$PKG_ROOT


COPY nginx.conf /etc/nginx/nginx.conf
COPY default.conf /etc/nginx/conf.d/default.conf

RUN rm -rf /fpm_install/var/

FROM slpcat/debian:bookworm
COPY --from=builder /fpm_install/ /
RUN \
    useradd nginx && \
    mkdir -p /var/cache/nginx/client_temp && \
    mkdir -p /var/log/nginx

RUN apt-get update && apt-get upgrade -y && apt-get install -y libxslt1.1 libgd3

#COPY nginx.conf /etc/nginx/nginx.conf

EXPOSE 80 443

CMD ["nginx", "-g", "daemon off;"]
