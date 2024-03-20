FROM buildpack-deps:jammy AS builder

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
ENV PYTHON_VERSION 3.11.3

RUN set -eux; \
	\
	wget -O python.tar.xz "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz"; \
	wget -O python.tar.xz.asc "https://www.python.org/ftp/python/${PYTHON_VERSION%%[a-z]*}/Python-$PYTHON_VERSION.tar.xz.asc"; \
	GNUPGHOME="$(mktemp -d)"; export GNUPGHOME; \
	#gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys "$GPG_KEY"; \
	#gpg --batch --verify python.tar.xz.asc python.tar.xz; \
	#command -v gpgconf > /dev/null && gpgconf --kill all || :; \
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

FROM nvidia/cuda:12.1.1-cudnn8-devel-ubuntu22.04 as base
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai" \
    PATH="~/.local/bin:/usr/local/bin:$PATH"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update && apt-get dist-upgrade -y && \
    apt-get install -y vim-tiny net-tools iproute2 procps curl wget telnet less

RUN \
    apt-get update -y && \
    apt-get install -y libexpat1 libgl1-mesa-glx libglib2.0-dev tk google-perftools git git-lfs pkg-config libcairo2-dev libreadline8 gcc g++ \
        build-essential \
        software-properties-common \
        python3-pip \
        python3-tk \
        python3-dev \
	python3-opencv \
        nodejs \
        npm \
        bash \
        dos2unix \
        git \
        git-lfs \
        ncdu \
        nginx \
        net-tools \
        inetutils-ping \
        openssh-server \
        libglib2.0-0 \
        libsm6 \
        libgl1 \
        libxrender1 \
        libxext6 \
        ffmpeg \
        wget \
        curl \
        psmisc \
        rsync \
        vim \
        zip \
        unzip \
        p7zip-full \
        htop \
        pkg-config \
        plocate \
        libcairo2-dev \
        libgoogle-perftools4 \
        libtcmalloc-minimal4 \
        apt-transport-https \
        ca-certificates && \
    update-ca-certificates

#install python3.11
COPY --from=builder /fpm_install /
COPY pip.conf /etc/pip.conf
RUN chmod 644 /etc/pip.conf

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
ARG PYTHON_PIP_VERSION=23.3.2
# https://github.com/docker-library/python/issues/365
ARG PYTHON_SETUPTOOLS_VERSION=69.0.3
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

RUN useradd -s /bin/bash -d /app chatglm \
    && mkdir -p /app/ \
    && chown -R chatglm:chatglm /app

USER chatglm

RUN   pip3 install triton xformers torch torchvision torchaudio --extra-index-url https://download.pytorch.org/whl/cu121

RUN \
    cd /app \
    && git clone https://github.com/THUDM/ChatGLM3 \
    && cd ChatGLM3 \
    && pip3 install gradio \
    && pip3 install -r requirements.txt

WORKDIR /app/ChatGLM3/
CMD ["streamlit", "run", "basic_demo/web_demo_streamlit.py"]
