#upstream https://github.com/debuerreotype/docker-debian-artifacts/blob/de09dd55b6328b37b89a33e76b698f9dbe611fab/jessie/backports/Dockerfile
FROM debian:bookworm
LABEL org.opencontainers.image.authors="slpcat@qq.com"

# Container variables
ENV \ 
    TERM="xterm-256color" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TZ="Asia/Shanghai"

RUN rm -f /etc/apt/sources.list.d/debian.sources
COPY sources.list /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TZ}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \ 
    && ln -sf /usr/share/zoneinfo/${TZ} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get update -y && \
    apt-get dist-upgrade -y && \
    apt-get install -y binutils ethtool vim-tiny net-tools iproute2 procps curl wget telnet less unzip && \
    rm -rf /var/lib/apt/lists/

CMD ["/bin/bash"]
