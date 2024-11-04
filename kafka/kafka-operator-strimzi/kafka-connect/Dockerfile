FROM slpcat/debian:bookworm AS builder
#https://docs.confluent.io/platform/current/connect/confluent-hub/index.html
#confluentinc-kafka-connect-jdbc
#confluentinc-kafka-connect-elasticsearch
#debezium-connector-jdbc
#debezium-connector-mysql
#Kafka-DolphinDB 连接器
#kafka-connect-hdfs
#doris-kafka-connector
#starrocks-connector-for-kafka
#kafka-connect-tdengine
#kafka-connect-mongodb
#kafka-connect-storage-cloud
#kafka-connect-s3
#kafka-connect-mqtt
#kafka-connect-redis
#kafka-connect-prometheus-metrics


WORKDIR /tmp
RUN \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mysql/3.0.1.Final/debezium-connector-mysql-3.0.1.Final-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-jdbc/$3.0.1.Final/debezium-connector-jdbc-3.0.1.Final-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-mongodb/3.0.1.Final/debezium-connector-mongodb-3.0.1.Final-plugin.tar.gz && \
    wget https://repo1.maven.org/maven2/io/debezium/debezium-connector-postgres/3.0.1.Final/debezium-connector-postgres-3.0.1.Final-plugin.tar.gz && \
    wget https://d2p6pa21dvn84.cloudfront.net/api/plugins/confluentinc/kafka-connect-jdbc/versions/10.8.0/confluentinc-kafka-connect-jdbc-10.8.0.zip && \
    tar -zvxf *.tar.gz && \
    unzip *.zip

FROM quay.io/strimzi/kafka:0.44.0-kafka-3.8.0
USER root:root
COPY --from=builder /tmp/plugins/ /opt/kafka/plugins/
USER 1001
MAINTAINER slpcat@qq.com
