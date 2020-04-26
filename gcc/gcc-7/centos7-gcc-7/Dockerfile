FROM slpcat/centos:7 AS builder

MAINTAINER 若虚 <slpcat@qq.com>

RUN  \
    yum update -y && \
    yum clean all

RUN \
    yum install -y \
        gcc \
        git \
        wget \
        gcc-c++ \
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
        zlib-devel \
        libxslt \
        libxslt-devel \
        libxml2 \
        libxml2-devel \
        gmp-devel \
        mpfr-devel \
        libmpc-devel \
        texinfo \
        bison \
        flex \
        gcc-gnat \
        #glibc-devel.i686 \
        #libgcc.i686 \
        perl-core \
        rpm-build

RUN \
     yum -y install ruby ruby-devel rubygems \
     && gem sources --add https://gems.ruby-china.com/ --remove https://rubygems.org/ \
     && gem install fpm


ARG GCC_VERSION=7.5.0
ARG PKG_ROOT=/fpm_install
ARG CFLAGS="-O2"

RUN \
    mkdir -p /usr/src \
    && cd /usr/src \
    && wget https://mirrors.tuna.tsinghua.edu.cn/gnu/gcc/gcc-$GCC_VERSION/gcc-$GCC_VERSION.tar.gz \
    && tar -zxC /usr/src -f gcc-$GCC_VERSION.tar.gz \
    && cd /usr/src/gcc-$GCC_VERSION \
    && ./configure --prefix=/usr/local \
             --disable-multilib \
             --enable-bootstrap \
             --enable-shared \
             --enable-threads=posix \
             --enable-checking=release \
             --with-system-zlib \
             --enable-__cxa_atexit \
             --disable-libunwind-exceptions \
             --enable-gnu-unique-object \
             --enable-linker-build-id \
             --with-linker-hash-style=gnu \
             #--enable-languages=c,c++,objc,obj-c++,fortran,ada,go,lto \
             --enable-languages=c,c++ \
             --enable-plugin \
             --enable-initfini-array \
             --disable-libgcj \
             --enable-gnu-indirect-function \
             --with-tune=generic \
             --with-arch_32=x86-64 \
             --build=x86_64-redhat-linux \
    && make -j4 \
    && make install DESTDIR=$PKG_ROOT

RUN \
    fpm -f --verbose \
    -n gcc7 \
    -s dir \
    --iteration 1.el7 \
    -v ${GCC_VERSION} \
    -t rpm \
    -m gnu \
    --vendor gnu.org \
    -a native \
    -p /root/ \
    -d 'libmpc' \
    -C $PKG_ROOT \
    --description 'gcc7 compiler' \
    #--conflicts 'nginx,tegine.openresty,kong' \
    --url 'http://gnu.org/en'
    #--before-install /before-install.sh \
    #--after-install /after-install.sh \
    #--after-remove /after-remove.sh \
    #--config-files /etc/nginx/nginx.conf

FROM slpcat/centos:7
COPY --from=builder /root/gcc7-7.5.0-1.el7.x86_64.rpm /root
RUN yum install -y /root/gcc7-7.5.0-1.el7.x86_64.rpm 

CMD ["/bin/bash"]
