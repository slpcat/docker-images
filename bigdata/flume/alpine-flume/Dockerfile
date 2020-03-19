FROM openjdk:8-alpine

MAINTAINER Juergen Jakobitsch <jakobitschj@semantic-web.at>

RUN apk add --update bash python3 && rm -rf /var/cache/apk/*

ADD apache-flume-1.7.0-SNAPSHOT-bin.tar.gz /usr/local/apache-flume/
RUN ln -s /usr/local/apache-flume/apache-flume-1.7.0-SNAPSHOT-bin /usr/local/apache-flume/current
RUN rm -f /tmp/apache-flume-1.7.0-SNAPSHOT-bin.tar.gz

ADD zookeeper-3.5.2-alpha.tar.gz /usr/local/apache-zookeeper/
RUN ln -s /usr/local/apache-zookeeper/zookeeper-3.5.2-alpha /usr/local/apache-zookeeper/current
RUN rm -f /tmp/zookeeper-3.5.2-alpha.tar.gz

ENV FLUME_HOME="/usr/local/apache-flume/current"
ENV ZK_HOME="/usr/local/apache-zookeeper/current"


COPY wait-for-step.sh /
COPY execute-step.sh /
COPY finish-step.sh /

RUN ln -s /usr/local/apache-flume/apache-flume-1.7.0-SNAPSHOT-bin/ /app
RUN ln -s /usr/local/apache-flume/apache-flume-1.7.0-SNAPSHOT-bin/conf /config

ADD flume-bin.py /app/bin/
ADD flume-init /app/bin/
ADD flume-env.sh /config/
