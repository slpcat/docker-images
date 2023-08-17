FROM slpcat/centos:7 AS builder

ENV PATH /usr/local/bin:/opt/bin:$PATH
ARG PYTHON_VERSION=3.10.11
ARG INSTALLATION_PREFIX="/usr/local"
ENV LD_LIBRARY_PATH="${INSTALLATION_PREFIX}/lib:$LD_LIBRARY_PATH"
ARG PKG_ROOT=/fpm_install

RUN \
    yum upgrade -y && \
    yum install -y \
        autogen \
        autoconf \
        bzip2 \
        gcc \
        geoip \
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
        #perl-core \
        #libcurl-devel \
        #protobuf-devel \
        #protobuf-compiler \
        bzip2-devel \
        expat-devel \
        gdbm-devel \
        ncurses-devel \
        openssl-devel \
        readline-devel \
        sqlite-devel \
        tk-devel \
        xz-devel \
        zlib-devel \
        python3-devel \
        libffi-devel

RUN \
    cd /usr/src \
    && wget https://www.python.org/ftp/python/${PYTHON_VERSION}/Python-${PYTHON_VERSION}.tgz \
    && tar -xf Python-${PYTHON_VERSION}.tgz \
    && cd Python-${PYTHON_VERSION} \
    && ./configure \
                --prefix=$INSTALLATION_PREFIX \
		--enable-loadable-sqlite-extensions \
		--enable-option-checking=fatal \
                --enable-shared \
		--with-system-expat \
		--without-ensurepip \
    && make -j $(nproc) \
    && make altinstall \
    && make altinstall DESTDIR=$PKG_ROOT \
    && ldconfig \
    && python3 --version

FROM slpcat/centos:7
MAINTAINER 若虚 <slpcat@qq.com>
ENV PATH /usr/local/bin:$PATH

RUN \
    yum upgrade -y && yum install -y wget git

COPY --from=builder /fpm_install /
COPY pip.conf /etc/pip.conf

RUN \
    echo "/usr/local/lib" >> /etc/ld.so.conf.d/usr-local.conf \
    && ldconfig \
    && cd /usr/local/bin && ln -s python3.9 python3 \
    && python3 --version

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ARG PYTHON_PIP_VERSION=23.1.2
# https://github.com/docker-library/python/issues/365
ARG PYTHON_SETUPTOOLS_VERSION=67.7.2
# https://github.com/pypa/get-pip
ARG PYTHON_GET_PIP_URL=https://bootstrap.pypa.io/pip/get-pip.py
#ARG PYTHON_GET_PIP_SHA256=1e501cf004eac1b7eb1f97266d28f995ae835d30250bec7f8850562703067dc6

RUN set -eux; \
        wget -O get-pip.py "$PYTHON_GET_PIP_URL"; \
        export PYTHONDONTWRITEBYTECODE=1; \
        python3 get-pip.py \
                --disable-pip-version-check \
                --no-cache-dir \
                --no-compile \
                "pip==$PYTHON_PIP_VERSION" \
                "setuptools==$PYTHON_SETUPTOOLS_VERSION" \
        ; \
        rm -f get-pip.py; \
        pip --version
