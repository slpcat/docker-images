FROM ubuntu:16.04
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list && \
    sed -i 's/security.ubuntu.com/mirrors.aliyun.com/' /etc/apt/sources.list

RUN apt-get update && apt-get install -y locales && rm -rf /var/lib/apt/lists/* \
    && localedef -i en_US -c -f UTF-8 -A /usr/share/locale/locale.alias en_US.UTF-8

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog tzdata \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

RUN DEBIAN_FRONTEND=noninteractive apt-get update && \
    apt-get install -y nano git make g++ autoconf python && \
    git clone https://github.com/ideawu/ssdb.git /tmp/ssdb --depth 1 && \
    cd /tmp/ssdb && make && make install && \
    mv /usr/local/ssdb /ssdb && \
    apt-get remove --purge -y git make g++ autoconf && \
    apt-get autoremove -y && \
    apt-get clean -y && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/* && \
    sed -e "s@home.*@home $(dirname /ssdb/var)@" \
        -e "s/loglevel.*/loglevel info/" \
        -e "s@work_dir = .*@work_dir = /ssdb/var@" \
        -e "s@pidfile = .*@pidfile = /run/ssdb.pid@" \
        -e "s@output:.*@output: stdout@" \
        -e "s@level:.*@level: info@" \
        -e "s@ip:.*@ip: 0.0.0.0@" \
        -i /ssdb/ssdb.conf

WORKDIR /ssdb
VOLUME /ssdb/var

EXPOSE 8888
CMD ["/ssdb/ssdb-server", "/ssdb/ssdb.conf"]
