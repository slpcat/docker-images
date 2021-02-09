#!/bin/bash
set -e
set -x

sed -i "/cluster.enable=/ s/=.*/=${CLUSTER_ENABLE}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/cluster.zookeeper.address=/ s/=.*/=${CLUSTER_ZOOKEEPER_ADDRESS}/g" /pinpoint/config/pinpoint-collector.properties
sed -i "/flink.cluster.enable=/ s/=.*/=${FLINK_CLUSTER_ENABLE}/" /pinpoint/config/pinpoint-collector.properties
sed -i "/flink.cluster.zookeeper.address=/ s/=.*/=${FLINK_CLUSTER_ZOOKEEPER_ADDRESS}/" /pinpoint/config/pinpoint-collector.properties

sed -i "/hbase.client.host=/ s/=.*/=${HBASE_HOST}/" /pinpoint/config/hbase.properties
sed -i "/hbase.client.port=/ s/=.*/=${HBASE_PORT}/" /pinpoint/config/hbase.properties
sed -i "/base.zookeeper.znode.parent=/ s/=.*/=\/${HBASE_ZNODE_PARENT}/" /pinpoint/config/hbase.properties
#sed -i "/hbase.namespace=/ s/=.*/=${HBASE_NAMESPACE}/" /pinpoint/config/hbase.properties

sed -i "/level value=/ s/=.*/=\"${DEBUG_LEVEL}\"\/>/g" /pinpoint/config/log4j.xml

exec java -jar /pinpoint/pinpoint-collector-boot.jar --spring.config.additional-location=/pinpoint/config/pinpoint-collector.properties
