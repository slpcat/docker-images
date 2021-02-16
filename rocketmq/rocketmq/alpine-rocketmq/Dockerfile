FROM slpcat/jdk:v1.8-alpine
MAINTAINER 若虚 <slpcat@qq.com>

# Rocketmq version
ENV ROCKETMQ_VERSION="4.8.0"
# Rocketmq home
ENV ROCKETMQ_HOME="/opt/rocketmq"
ENV JAVA_OPT=" -Duser.home=/opt/rocketmq"

RUN set -ex && \
    apk update && \
    apk upgrade && \
    apk add shadow &&\
    groupadd rocketmq && \
    useradd -g rocketmq -s /bin/bash -c RocketMQ rocketmq  && \
    mkdir -p /home/rocketmq && \
    chown -R rocketmq:rocketmq /home/rocketmq

# install from source
#RUN cd /opt && \
#    git clone https://github.com/apache/incubator-rocketmq.git
#WORKDIR /home/admin/incubator-rocketmq
#    mvn -Prelease-all -DskipTests clean install -U
#cd distribution/target/apache-rocketmq
# install from binary
RUN \
    cd /opt && \
    wget https://mirrors.tuna.tsinghua.edu.cn/apache/rocketmq/${ROCKETMQ_VERSION}/rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip && \
    unzip rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip && \
    rm -rf rocketmq-all-${ROCKETMQ_VERSION}-bin-release.zip && \
    mv rocketmq-all-${ROCKETMQ_VERSION}-bin-release rocketmq && \
    chown -R rocketmq:rocketmq /opt/rocketmq

USER rocketmq
COPY runbroker.sh /opt/rocketmq/bin/runbroker.sh
COPY runserver.sh /opt/rocketmq/bin/runserver.sh
COPY rkGenConfig.sh /opt/rocketmq/bin/rkGenConfig.sh
WORKDIR /opt/rocketmq/bin
EXPOSE 9876 10909 10911
CMD  ["sh", "-c", ". ./play.sh; while sleep 60; do echo RocketMQ, GO ROCK; done"]
