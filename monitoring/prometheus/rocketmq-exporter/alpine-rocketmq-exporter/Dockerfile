FROM  maven:3.5.3 AS build
MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US:en" \
    LC_ALL="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

RUN \
    sed -i 's/deb.debian.org/mirrors.aliyun.com/' /etc/apt/sources.list

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

ENV JAVA_OPTS="-Drocketmq.namesrv.addr=127.0.0.1:9876 -Dcom.rocketmq.sendMessageWithVIPChannel=false"

# install from source
RUN \
    mkdir -p /opt/rocketmq && \
    cd /opt/rocketmq && \
    git clone https://github.com/apache/rocketmq-exporter.git

WORKDIR /opt/rocketmq/rocketmq-exporter
RUN \
    mvn clean package -Dmaven.test.skip=true

FROM slpcat/jdk:alpine
ENV JAVA_OPTS=""
RUN \
    mkdir -p /opt/rocketmq-exporter/config && \
    cd /opt/rocketmq-exporter 
COPY --from=build /opt/rocketmq/rocketmq-exporter/target/rocketmq-exporter-0.0.2-SNAPSHOT.jar /opt/rocketmq-exporter
COPY --from=build /opt/rocketmq/rocketmq-exporter/target/classes /opt/rocketmq-exporter/classes
WORKDIR /opt/rocketmq-exporter
EXPOSE 5557

CMD ["sh", "-c", "java $JAVA_OPTS -jar rocketmq-exporter-0.0.2-SNAPSHOT.jar"]
