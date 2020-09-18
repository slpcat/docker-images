#!/bin/bash
set -e

cat << EOF > consumer.config
#新版consumer摈弃了对zookeeper的依赖，使用bootstrap.servers告诉consumer kafka server的位置
bootstrap.servers=$SRC_KAFKA_BROKERS
 
#如果使用旧版Consumer，则使用zookeeper.connect
#zookeeper.connect=ip-188-33-33-32.eu-central-1.compute.internal:2181,ip-188-33-33-33.eu-central-1.compute.internal:2181
#1.compute.internal:2181
#change the default 40000 to 50000
request.timeout.ms=60000

exclude.internal.topics=true
#sasl.mechanism=PLAIN
#security.protocol=SASL_SSL
#sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="$SRC_KAFKA_USERNAME" password="$SRC_KAFKA_PASSWORD";

#hange default heartbeat interval from 3000 to 15000
heartbeat.interval.ms=30000
 
#change default session timeout from 30000 to 40000
session.timeout.ms=40000
#consumer group id
group.id=$KAFKA_CONSUMER_ID
partition.assignment.strategy=org.apache.kafka.clients.consumer.RoundRobinAssignor
#restrict the max poll records from 2147483647 to 200000
max.poll.records=20000

#When using shallow.iterator.enable=true on the consumer side, the performance gain is big (when incoming messages are compressed) and the producer does not complain but write the messages uncompressed without the compression flag.
#shallow.iterator.enable=true

#set receive buffer from default 64kB to 512kb
receive.buffer.bytes=524288
partition.assignment.strategy=org.apache.kafka.clients.consumer.RoundRobinAssignor
#fetch.min.bytes=65536
fetch.max.bytes=524288
 
#set max amount of data per partition to override default 1048576
max.partition.fetch.bytes=5248576
#consumer timeout
#consumer.timeout.ms=5000

EOF


cat << EOF > producer.config
bootstrap.servers=$DST_KAFKA_BROKERS
 
# name of the partitioner class for partitioning events; default partition spreads data randomly
#partitioner.class=
 
# specifies whether the messages are sent asynchronously (async) or synchronously (sync)
producer.type=sync

request.timeout.ms=10000
#sasl.mechanism=PLAIN
#security.protocol=SASL_SSL
#sasl.jaas.config=org.apache.kafka.common.security.plain.PlainLoginModule required username="$DST_KAFKA_USERNAME" password="$DST_KAFKA_PASSWORD";

max.in.flight.requests.per.connection=1024
#linger.ms=2000
batch.size=65536

# specify the compression codec for all data generated: none, gzip, snappy, lz4.
# the old config values work as well: 0, 1, 2, 3 for none, gzip, snappy, lz4, respectively
#compression.codec=none
# message encoder
#serializer.class=kafka.serializer.DefaultEncoder

EOF
kafka-mirror-maker --consumer.config consumer.config --producer.config producer.config --num.streams $NUM_STREAMS —num.producers $NUM_PRODUCERS --whitelist="$TOPIC_LIST"
