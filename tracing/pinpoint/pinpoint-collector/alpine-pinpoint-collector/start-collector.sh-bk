#!/bin/bash
set -e
set -x

sed -i "/cluster.enable=/ s/=.*/=${CLUSTER_ENABLE:-true}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/cluster.zookeeper.address=/ s/=.*/=${CLUSTER_ZOOKEEPER_ADDRESS:-localhost}/g" /pinpoint/config/pinpoint-collector.properties
sed -i "/flink.cluster.enable=/ s/=.*/=${FLINK_CLUSTER_ENABLE:-false}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/flink.cluster.zookeeper.address=/ s/=.*/=${FLINK_CLUSTER_ZOOKEEPER_ADDRESS:-localhost}/" /pinpoint/config/pinpoint-collector.properties

sed -i "/hbase.client.host=/ s/=.*/=${HBASE_HOST:-localhost}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/hbase.client.port=/ s/=.*/=${HBASE_PORT:-2181}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/base.zookeeper.znode.parent=/ s/=.*/=${HBASE_ZNODE_PARENT:-\/hbase}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/hbase.namespace=/ s/=.*/=${HBASE_NAMESPACE:-default}/" /pinpoint/config/pinpoint-collector.properties

#sed -i "/level value=/ s/=.*/=\"${DEBUG_LEVEL}\"\/>/g" /pinpoint/config/log4j.xml

exec java -jar /pinpoint/pinpoint-collector-boot.jar --spring.config.additional-location=/pinpoint/config/pinpoint-collector.properties
