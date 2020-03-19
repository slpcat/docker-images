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

CMD ["sbt"]
