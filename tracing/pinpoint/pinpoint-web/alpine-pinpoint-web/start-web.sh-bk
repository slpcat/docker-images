#!/bin/bash
set -e
set -x

sed -i "/cluster.enable=/ s/=.*/=${CLUSTER_ENABLE}/" /pinpoint/config/pinpoint-web.properties
sed -i "/cluster.zookeeper.address=/ s/=.*/=${CLUSTER_ZOOKEEPER_ADDRESS}/g" /pinpoint/config/pinpoint-web.properties
#sed -i "/cluster.web.tcp.port=/ s/=.*/=${CLUSTER_WEB_TCP_PORT}/" /pinpoint/config/pinpoint-web.properties
sed -i "/admin.password=/ s/=.*/=${ADMIN_PASSWORD}/" /pinpoint/config/pinpoint-web.properties
sed -i "/config.sendUsage=/ s/=.*/=${ANALYTICS}/" /pinpoint/config/pinpoint-web.properties
sed -i "/config.show.applicationStat=/ s/=.*/=${SHOW_APPLICATIONSTAT}/" /pinpoint/config/pinpoint-web.properties

sed -i "/hbase.client.host=/ s/=.*/=${HBASE_HOST}/" /pinpoint/config/pinpoint-web.properties
sed -i "/hbase.client.port=/ s/=.*/=${HBASE_PORT}/" /pinpoint/config/pinpoint-web.properties
sed -i "/base.zookeeper.znode.parent=/ s/=.*/=\/${HBASE_ZNODE_PARENT}/" /pinpoint/config/pinpoint-web.properties
#sed -i "/hbase.namespace=/ s/=.*/=${HBASE_NAMESPACE}/" /pinpoint/config/pinpoint-web.properties

sed -i "/batch.enable=/ s/=.*/=${BATCH_ENABLE}/" /pinpoint/config/pinpoint-web.properties
sed -i "/batch.server.ip=/ s/=.*/=${BATCH_SERVER_IP}/" /pinpoint/config/pinpoint-web.properties
sed -i "/batch.flink.server=/ s/=.*/=${BATCH_FLINK_SERVER}/" /pinpoint/config/pinpoint-web.properties

#sed -i "/level value=/ s/=.*/=\"${DEBUG_LEVEL}\"\/>/g" /pinpoint/config/log4j.xml

echo "jdbc.driverClassName=${JDBC_DRIVER_CLASS_NAME}" > /pinpoint/config/pinpoint-web.properties
echo "jdbc.url=${JDBC_URL}" >> /pinpoint/config/pinpoint-web.properties
echo "jdbc.username=${JDBC_USERNAME}" >> /pinpoint/config/pinpoint-web.properties
echo "jdbc.password=${JDBC_PASSWORD}" >> /pinpoint/config/pinpoint-web.properties

exec java -jar /pinpoint/pinpoint-web-boot.jar --spring.config.additional-location=/pinpoint/config/pinpoint-web.properties
