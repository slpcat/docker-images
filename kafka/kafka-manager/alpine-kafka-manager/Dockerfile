#upstream https://github.com/sheepkiller/kafka-manager-docker
FROM slpcat/jdk:v1.8-alpine as builder
MAINTAINER 若虚 <slpcat@qq.com>

ENV SBT_VERSION 1.3.8
ENV SCALA_VERSION 2.12.10
ENV SCALA_HOME /usr/local/share/scala
RUN export PATH=$PATH:${SCALA_HOME}/bin

#install scala and sbt
RUN wget http://downloads.typesafe.com/scala/${SCALA_VERSION}/scala-${SCALA_VERSION}.tgz && \
    #wget http://repo.typesafe.com/typesafe/ivy-releases/org.scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar && \
    wget https://dl.bintray.com/sbt/maven-releases/org/scala-sbt/sbt-launch/${SBT_VERSION}/sbt-launch.jar && \
    mkdir -p ~/bin && touch ~/bin/sbt && \
    echo '#!/bin/sh' | tee -a ~/bin/sbt && \
    echo 'SBT_OPTS="-Xms512M -Xmx1536M -Xss1M -XX:+CMSClassUnloadingEnabled"' | tee -a ~/bin/sbt && \
    echo 'java $SBT_OPTS -jar /sbt-launch.jar "$@"' | tee -a ~/bin/sbt && \
    chmod +x ~/bin/sbt && \
    ln -s ~/bin/sbt /usr/local/bin/sbt && \
    tar xvzf scala-${SCALA_VERSION}.tgz && \
    mv scala-${SCALA_VERSION} ${SCALA_HOME} && \
    rm -f scala-${SCALA_VERSION}.tgz

#change sbt repo
COPY repositories /root/.sbt/repositories

# compile a non-existent project to pre-download sbt dependencies
RUN sbt compile

ENV \
    ZK_HOSTS=localhost:2181 \
    KM_VERSION=3.0.0.5 \
    KM_REVISION=eba0b95ac4e4469b536a36c8ee2c46cfde2278a4 \
    KM_CONFIGFILE="conf/application.conf"

ADD start-kafka-manager.sh /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

RUN \
    apk add git && \
    mkdir -p /tmp && \
    cd /tmp && \
    #git clone https://github.com/yahoo/kafka-manager && \
    git clone https://github.com/yahoo/CMAK.git && \
    cd /tmp/CMAK && \
    git checkout ${KM_REVISION} && \
    #echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
    sbt clean dist && \
    unzip  -d / ./target/universal/kafka-manager-${KM_VERSION}.zip && \
    rm -fr /tmp/* /root/.sbt /root/.ivy2 && \
    chmod +x /kafka-manager-${KM_VERSION}/start-kafka-manager.sh

WORKDIR /kafka-manager-${KM_VERSION}

EXPOSE 9000
ENTRYPOINT ["./start-kafka-manager.sh"]
