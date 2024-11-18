FROM slpcat/debian:bookworm AS builder
RUN \
    apt-get update -y && \
    apt-get install -y unzip

#https://docs.confluent.io/platform/current/connect/kafka_connectors.html
#https://github.com/apache/camel-kafka-connector
#https://camel.apache.org/camel-kafka-connector/4.8.x/reference/index.html
#confluentinc-kafka-connect-jdbc
#confluentinc-kafka-connect-elasticsearch
#debezium-connector-jdbc
#debezium-connector-mysql
#Kafka-DolphinDB 连接器
#kafka-connect-hdfs
#kafka-connect-hive sink
#kafka-connect-hbase sink
#kafka-connect Milvus 
#kafka-connect-rsyslog
#doris-kafka-connector
#starrocks-connector-for-kafka
#kafka-connect-tdengine
#kafka-connect-mongodb
#kafka-connect-storage-cloud
#kafka-connect-s3
#kafka-connect-mqtt
#kafka-connect-redis
#iotdb-kafka-sink-connector
#kafka-connect-prometheus-metrics
#git clone https://github.com/liketic/kafka-connect-logservice.git
#mvn clean compile assembly:single 
#camel-aws-s3-sink-kafka-connector
#camel-aws-s3-source-kafka-connector

ARG DEBEZIUM_VERSION=3.0.1.Final
ARG CONFLUENTINC_VERSION=10.8.0
WORKDIR /tmp/plugins/
RUN \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/${DEBEZIUM_VERSION}/debezium-connector-mysql-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    tar zvxf debezium-connector-mysql-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-jdbc/${DEBEZIUM_VERSION}/debezium-connector-jdbc-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    tar zvxf debezium-connector-jdbc-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/${DEBEZIUM_VERSION}/debezium-connector-mongodb-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    tar zvxf debezium-connector-mongodb-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/${DEBEZIUM_VERSION}/debezium-connector-postgres-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    tar zvxf debezium-connector-postgres-${DEBEZIUM_VERSION}-plugin.tar.gz && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/confluentinc/kafka-connect-jdbc/versions/${CONFLUENTINC_VERSION}/confluentinc-kafka-connect-jdbc-${CONFLUENTINC_VERSION}.zip && \
    unzip confluentinc-kafka-connect-jdbc-${CONFLUENTINC_VERSION}.zip && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/confluentinc/kafka-connect-s3/versions/10.5.17/confluentinc-kafka-connect-s3-10.5.17.zip && \
    unzip confluentinc-kafka-connect-s3-10.5.17.zip && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/confluentinc/kafka-connect-s3-source/versions/2.6.7/confluentinc-kafka-connect-s3-source-2.6.7.zip && \
    unzip confluentinc-kafka-connect-s3-source-2.6.7.zip && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/confluentinc/kafka-connect-elasticsearch/versions/14.1.2/confluentinc-kafka-connect-elasticsearch-14.1.2.zip && \
    unzip confluentinc-kafka-connect-elasticsearch-14.1.2.zip && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/jcustenborder/kafka-connect-redis/versions/0.0.8/jcustenborder-kafka-connect-redis-0.0.8.zip && \
    unzip jcustenborder-kafka-connect-redis-0.0.8.zip && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/redis/redis-kafka-connect/versions/0.9.1/redis-redis-kafka-connect-0.9.1.zip && \
    unzip redis-redis-kafka-connect-0.9.1.zip && \
    wget https://github.com/StarRocks/starrocks-connector-for-kafka/releases/download/v1.0.4/starrocks-kafka-connector-1.0.4.tar.gz && \
    tar zvxf starrocks-kafka-connector-1.0.4.tar.gz && \
    wget https://repo1.maven.org/maven2/org/apache/doris/doris-kafka-connector/1.1.0/doris-kafka-connector-1.1.0.jar && \
    wget https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-aws-s3-sink-kafka-connector/4.8.0/camel-aws-s3-sink-kafka-connector-4.8.0-package.tar.gz && \
    tar zvxf camel-aws-s3-sink-kafka-connector-4.8.0-package.tar.gz && \
    wget https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-aws-s3-source-kafka-connector/4.8.0/camel-aws-s3-source-kafka-connector-4.8.0-package.tar.gz && \
    tar zvxf camel-aws-s3-source-kafka-connector-4.8.0-package.tar.gz && \
    wget https://repo1.maven.org/maven2/org/apache/camel/kafkaconnector/camel-aws2-s3-kafka-connector/0.11.5/camel-aws2-s3-kafka-connector-0.11.5.jar &&\
    wget https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-minio-sink-kafka-connector/4.8.0/camel-minio-sink-kafka-connector-4.8.0-package.tar.gz && \
    tar zvxf camel-minio-sink-kafka-connector-4.8.0-package.tar.gz && \
    wget https://repo.maven.apache.org/maven2/org/apache/camel/kafkaconnector/camel-minio-source-kafka-connector/4.8.0/camel-minio-source-kafka-connector-4.8.0-package.tar.gz && \
    rm *.tar.gz *.zip 

FROM quay.io/strimzi/kafka:0.44.0-kafka-3.7.1
USER root:root
COPY --from=builder /tmp/plugins/ /opt/kafka/plugins/
USER 1001
LABEL org.opencontainers.image.authors="slpcat@qq.com"

