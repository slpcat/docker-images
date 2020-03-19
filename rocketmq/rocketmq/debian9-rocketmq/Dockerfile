#FROM  maven:3.5.3
FROM openjdk:8-jdk-stretch
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN echo 'deb http://mirrors.aliyun.com/debian stretch-backports main' > /etc/apt/sources.list.d/backports.list \
    && sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list \
    && sed -i 's/security.debian.org/mirrors.aliyun.com\/debian-security/' /etc/apt/sources.list

# Set timezone and locales
RUN \
    echo "${TIMEZONE}" > /etc/timezone \
    && echo "$LANG UTF-8" > /etc/locale.gen \
    && apt-get update -q \
    && DEBIAN_FRONTEND=noninteractive apt-get install -yq apt-utils dialog vim-tiny locales \
    && ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime \
    && update-locale LANG=$LANG \
    && locale-gen $LANG \
    && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure locales

# Install required packages
RUN \
    apt-get upgrade -y

# Rocketmq version
ENV ROCKETMQ_VERSION="4.1.0"
# Rocketmq home
ENV ROCKETMQ_HOME="/opt/rocketmq"

ENV JAVA_OPT=" -Duser.home=/opt/rocketmq"

RUN groupadd rocketmq && \
    useradd -g rocketmq -s /bin/bash -c RocketMQ rocketmq  && \
    mkdir /home/rocketmq && \
    chown -R rocketmq:rocketmq /home/rocketmq

# install from source
#RUN cd /opt && \
#    git clone https://github.com/apache/incubator-rocketmq.git
#WORKDIR /home/admin/incubator-rocketmq
#    mvn -Prelease-all -DskipTests clean install -U
#cd distribution/target/apache-rocketmq
# install from binary
RUN cd /opt && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq/${ROCKETMQ_VERSION}-incubating/rocketmq-all-${ROCKETMQ_VERSION}-incubating-bin-release.zip && \
    unzip rocketmq-all-${ROCKETMQ_VERSION}-incubating-bin-release.zip && \
    rm -rf rocketmq-all-${ROCKETMQ_VERSION}-incubating-bin-release.zip && \
    mv rocketmq-all-${ROCKETMQ_VERSION}-incubating rocketmq && \
    chown -R rocketmq:rocketmq /opt/rocketmq

USER rocketmq
WORKDIR /opt/rocketmq/bin
EXPOSE 9876 10909 10911
CMD  ["sh", "-c", ". ./play.sh; while sleep 10; do echo RocketMQ, GO ROCK; done"]
