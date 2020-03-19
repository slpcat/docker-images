#upstream https://github.com/sheepkiller/kafka-manager-docker
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
    yum install -y wget && \
    wget --no-check-certificate --no-cookies --header "Cookie: oraclelicense=accept-securebackup-cookie" http://download.oracle.com/otn-pub/java/jdk/8u171-b11/512cd62ec5174c3487ac17c61aaa89e8/jdk-8u171-linux-x64.rpm && \
    rpm -ivh jdk-8u171-linux-x64.rpm && \
    rm jdk-8u171-linux-x64.rpm

ENV SBT_VERSION 0.13.9
ENV SCALA_VERSION 2.11.9
ENV SCALA_HOME /usr/local/share/scala
RUN export PATH=$PATH:${SCALA_HOME}/bin

RUN wget http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz && \
    wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar && \
    mkdir -p ~/bin && touch ~/bin/sbt && \
    echo '#!/bin/sh' | tee -a ~/bin/sbt && \
    echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"' | tee -a ~/bin/sbt && \
    echo 'java $SBT_OPTS -jar /sbt-launch.jar "$@"' | tee -a ~/bin/sbt && \
    chmod +x ~/bin/sbt && \
    ln -s ~/bin/sbt /usr/local/bin/sbt && \
    tar xvzf scala-${SCALA_VERSION}.tgz && \
    mv scala-${SCALA_VERSION} ${SCALA_HOME} && \
    rm -f scala-${SCALA_VERSION}.tgz

# compile a non-existent project to pre-download sbt dependencies
RUN sbt compile

ENV JAVA_HOME=/usr/java/jdk1.8.0_171 \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=1.3.3.17 \
    KM_REVISION=0356db5f2698c36ec676b947c786b8543086dd49 \
    KM_CONFIGFILE="conf/application.conf"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN yum install -y git wget unzip which && \
    mkdir -p /tmp && \
    cd /tmp && \
    git clone https://github.com/yahoo/kafka-manager && \
    cd /tmp/kafka-manager && \
    git checkout ${KM_REVISION} && \
    echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh && \
    yum autoremove -y git wget unzip which && \
    yum clean all

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
