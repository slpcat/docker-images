FROM  apache/nifi:latest
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \ 
    TERM="xterm" \
    LANG="en_US.UTF-8" \ 
    LANGUAGE="en_US.UTF-8" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

USER root

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list 

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny curl locales \ 
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get dist-upgrade -y

#/opt/nifi/nifi-current/lib
#install jdbc drivers
RUN \
    mkdir -p /opt/jdbc \
    && cd /opt/jdbc \
    && wget https://dev.mysql.com/get/Downloads/Connector-J/mysql-connector-java-8.0.19.tar.gz \
    && tar -zxf mysql-connector-java-8.0.19.tar.gz \
    && mv mysql-connector-java-8.0.19/mysql-connector-java-8.0.19.jar . \
    && rm -f mysql-connector-java-8.0.19.tar.gz \
    && rm -rf mysql-connector-java-8.0.19 \
    && wget https://jdbc.postgresql.org/download/postgresql-42.2.10.jar \
    && wget https://github.com/ClickHouse/clickhouse-jdbc/releases/download/release_0.2.4/clickhouse-jdbc-0.2.4.jar

USER nifi
