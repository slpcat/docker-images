FROM scratch
LABEL maintainer="若虚 <slpcat@qq.com>"

# Container variables
ENV \ 
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

#ADD antix-net.tgz /
ADD antix-core.tgz /

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog locales \ 
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y binutils ethtool vim-tiny net-tools iproute2 procps curl wget telnet less && \
    rm -rf /var/lib/apt/lists/

CMD ["/bin/bash"]
