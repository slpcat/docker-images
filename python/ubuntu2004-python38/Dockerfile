FROM buildpack-deps:focal AS builder

# ensure local python is preferred over distribution python
ENV PATH /usr/local/bin:$PATH

# http://bugs.python.org/issue19846
# > At the moment, setting "LANG=C" on a Linux system *fundamentally breaks Python 3*, and that's not OK.
ENV LANG C.UTF-8

# runtime dependencies
RUN set -eux; \
	apt-get update; \
	apt-get install -y --no-install-recommends \
		libbluetooth-dev \
		tk-dev \
		uuid-dev \
	; \
	rm -rf /var/lib/apt/lists/*

ARG PKG_ROOT=/fpm_install
ENV GPG_KEY E3FF2839C048B25C084DEBE9B26995E310250568
ENV PYTHON_VERSION 3.8.17

RUN set -eux; \
	\
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; \
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
	gpg --batch --verify python.tar.xz.asc python.tar.xz; \
	command -v gpgconf > /dev/null && gpgconf --kill all || :; \
	rm -rf "$GNUPGHOME" python.tar.xz.asc; \
	mkdir -p /usr/src/python; \
	tar --extract --directory /usr/src/python --strip-components=1 --file python.tar.xz; \
	rm python.tar.xz; \
	\
	cd /usr/src/python; \
	gnuArch="$(dpkg-architecture --query DEB_BUILD_GNU_TYPE)"; \
	./configure \
		--build="$gnuArch" \
		--enable-loadable-sqlite-extensions \
		--enable-optimizations \
		--enable-option-checking=fatal \
		--enable-shared \
		--with-system-expat \
		--without-ensurepip \
	; \
	nproc="$(nproc)"; \
	make -j "$nproc"; \
	make install; \
        make install DESTDIR=$PKG_ROOT; \
	ldconfig; \
	python3 --version

#upstream https://github.com/jenkinsci/docker-inbound-agent
FROM slpcat/ubuntu:20.04
MAINTAINER 若虚 <slpcat@qq.com>

ENV PATH /usr/local/bin:$PATH

USER root

RUN \
    apt-get update && apt-get -y upgrade && apt-get install -y wget libexpat1 git

COPY --from=builder /fpm_install /

RUN \
    ldconfig \
    && python3 --version

# make some useful symlinks that are expected to exist ("/usr/local/bin/python" and friends)
RUN set -eux; \
        for src in idle3 pydoc3 python3 python3-config; do \
                dst="$(echo "$src" | tr -d 3)"; \
                [ -s "/usr/local/bin/$src" ]; \
                [ ! -e "/usr/local/bin/$dst" ]; \
                ln -svT "$src" "/usr/local/bin/$dst"; \
        done

# if this is called "PIP_VERSION", pip explodes with "ValueError: invalid truth value '<VERSION>'"
ARG PYTHON_PIP_VERSION=23.2.1
# https://github.com/docker-library/python/issues/365
ARG PYTHON_SETUPTOOLS_VERSION=68.2.2
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
