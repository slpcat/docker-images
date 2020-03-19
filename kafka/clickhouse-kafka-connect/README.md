clickhouse-kafka-connect
Ingress data from kafka topic into clickhouse table (JSON format) with the help of kafka connect.

Schema mapping is based on clickhouse table metadata.

Quickstart
Run kafka broker

# run zookeeper
docker run -itd --name zookeeper -p 2181:2181 -m 512m zookeeper

# run kafka
docker run -itd \
    --name kafka \
    --rm \
    -m 2048m \
    --hostname localhost \
    --link zookeeper:zookeeper \
    -p 9092:9092 \
    --env KAFKA_ADVERTISED_HOST_NAME=127.0.0.1 \
    --env ZOOKEEPER_IP=127.0.0.1 \
    --env ZOOKEEPER_CHROOT=/kafka_v_0_10 \
    --env KAFKA_DEFAULT_REPLICATION_FACTOR=1 \
    dmitryb/kafka-0.10.2.1:1.0


# create kafka topic
kafka-topics.sh --create --zookeeper localhost:2181/kafka_v_0_10 --replication-factor 1 --partitions 3 --topic table10-json
Run clickhouse server

# run clickhouse server
docker run -itd --name clickhouse -p 8123:8123 -p 9000:9000 dmitryb/clickhouse-server:latest

# open clickhouse client

docker run -it --rm --net=host yandex/clickhouse-client -h localhost

# create db & table
CREATE DATABASE IF NOT EXISTS DB01;

USE DB01;

CREATE TABLE IF NOT EXISTS DB01.Table10 ON CLUSTER default_cluster
(
    UpdateDate Date,    
    GeoHash String,    
    NChecked UInt32,
    NBooked Nullable(UInt32)    
) ENGINE = MergeTree(UpdateDate, (GeoHash, UpdateDate), 8192);

# create cluster table (if using cluster config)
CREATE TABLE IF NOT EXISTS DB01.Table10_c ON CLUSTER default_cluster as DB01.Table10
ENGINE = Distributed(default_cluster, DB01, Table10, cityHash64(GeoHash));
Run kafka connect

# download and install kafka connect (or use docker image)
# https://www.confluent.io/download/

# run connect
./bin/connect-standalone ./configuration/connect-standalone.properties ./configuration/clickhouse-sink.properties

# send data to kafka topic
echo  '{"UpdateDate": "2018-04-12", "GeoHash": "geo01", "NChecked": 10, NBooked: 3}' | kafka-console-producer.sh --broker-list localhost:9092 --topic table10-json

# query clickhouse table
