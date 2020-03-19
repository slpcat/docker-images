FROM centos:7

MAINTAINER 若虚 <slpcat@qq.com>

# Container variables
ENV \
    TERM="xterm" \
    LANG="en_US.UTF-8" \
    LANGUAGE="en_US.UTF-8" \
    TIMEZONE="Asia/Shanghai"

COPY epel.repo /etc/yum.repos.d/
COPY java.sh /etc/profile.d/

# set timezone
RUN ln -sf /usr/share/zoneinfo/${TIMEZONE} /etc/localtime

RUN \
    yum update -y && \
    yum install -y wget unzip && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm && \
    rpm -ivh jdk-8u171-linux-x64.rpm && \
    rm jdk-8u171-linux-x64.rpm

# Rocketmq version
ENV ROCKETMQ_VERSION="4.1.0"
# Rocketmq home
ENV ROCKETMQ_HOME="/opt/rocketmq"
ENV JAVA_HOME="/usr/java/jdk1.8.0_171-amd64"
ENV JAVA_OPT=" -Duser.home=/opt/rocketmq"

RUN groupadd rocketmq && \
    useradd -g rocketmq -s /bin/bash -c RocketMQ rocketmq  && \
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
COPY runbroker.sh /opt/rocketmq/bin/runbroker.sh
WORKDIR /opt/rocketmq/bin
EXPOSE 9876 10909 10911
CMD  ["sh", "-c", ". ./play.sh; while sleep 60; do echo RocketMQ, GO ROCK; done"]
