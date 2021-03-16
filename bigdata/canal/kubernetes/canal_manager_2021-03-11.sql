# ************************************************************
# Sequel Pro SQL dump
# Version 4541
#
# http://www.sequelpro.com/
# https://github.com/sequelpro/sequelpro
#
# Host: 127.0.0.1 (MySQL 5.7.30-log)
# Database: canal_manager
# Generation Time: 2021-03-11 02:14:02 +0000
# ************************************************************


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;
/*!40014 SET @OLD_FOREIGN_KEY_CHECKS=@@FOREIGN_KEY_CHECKS, FOREIGN_KEY_CHECKS=0 */;
/*!40101 SET @OLD_SQL_MODE=@@SQL_MODE, SQL_MODE='NO_AUTO_VALUE_ON_ZERO' */;
/*!40111 SET @OLD_SQL_NOTES=@@SQL_NOTES, SQL_NOTES=0 */;


# Dump of table canal_adapter_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `canal_adapter_config`;

CREATE TABLE `canal_adapter_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `category` varchar(45) NOT NULL,
  `name` varchar(45) NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `content` text NOT NULL,
  `modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `canal_adapter_config` WRITE;
/*!40000 ALTER TABLE `canal_adapter_config` DISABLE KEYS */;

INSERT INTO `canal_adapter_config` (`id`, `category`, `name`, `status`, `content`, `modified_time`)
VALUES
	(1,'es7','mytest_user.yml',NULL,'dataSourceKey: defaultDS\ndestination: example01\ngroupId: g1\nesMapping:\n  _index: mytest_user\n  _id: _id\n#  upsert: true\n#  pk: id\n  sql: \"select a.id as _id, a.name, a.role_id, b.role_name,\n        a.c_time from user a\n        left join role b on b.id=a.role_id\"\n#  objFields:\n#    _labels: array:;\n  etlCondition: \"where a.c_time>={}\"\n  commitBatch: 3000','2021-03-11 02:08:09');

/*!40000 ALTER TABLE `canal_adapter_config` ENABLE KEYS */;
UNLOCK TABLES;


# Dump of table canal_config
# ------------------------------------------------------------

DROP TABLE IF EXISTS `canal_config`;

CREATE TABLE `canal_config` (
  `id` bigint(20) NOT NULL AUTO_INCREMENT,
  `cluster_id` bigint(20) DEFAULT NULL,
  `server_id` bigint(20) DEFAULT NULL,
  `name` varchar(45) NOT NULL,
  `status` varchar(45) DEFAULT NULL,
  `content` text NOT NULL,
  `content_md5` varchar(128) NOT NULL,
  `modified_time` timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
  PRIMARY KEY (`id`),
  UNIQUE KEY `sid_UNIQUE` (`server_id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

LOCK TABLES `canal_config` WRITE;
/*!40000 ALTER TABLE `canal_config` DISABLE KEYS */;

INSERT INTO `canal_config` (`id`, `cluster_id`, `server_id`, `name`, `status`, `content`, `content_md5`, `modified_time`)
VALUES
	(1,1,NULL,'canal.properties',NULL,'#################################################\n######### 		common argument		#############\n#################################################\n# tcp bind ip\ncanal.ip=\n# register ip to zookeeper\ncanal.register.ip=\ncanal.port=11111\ncanal.metrics.pull.port=11112\n# canal instance user/passwd\ncanal.user=\ncanal.passwd=\n\n# canal admin config\ncanal.admin.manager=canal-admin:8089\ncanal.admin.port=11110\ncanal.admin.user=admin\ncanal.admin.passwd=4ACFE3202A5FF5CF467898FC58AAB1D615029441\n\ncanal.zkServers=zk-cs:2181\n# flush data to zk\ncanal.zookeeper.flush.period=1000\ncanal.withoutNetty=false\n# tcp, kafka, RocketMQ\ncanal.serverMode=tcp\n# flush meta cursor/parse position to file\ncanal.file.data.dir=${canal.conf.dir}\ncanal.file.flush.period=1000\n## memory store RingBuffer size, should be Math.pow(2,n)\ncanal.instance.memory.buffer.size=16384\n## memory store RingBuffer used memory unit size , default 1kb\ncanal.instance.memory.buffer.memunit=1024\n## meory store gets mode used MEMSIZE or ITEMSIZE\ncanal.instance.memory.batch.mode=MEMSIZE\ncanal.instance.memory.rawEntry=true\n\n## detecing config\ncanal.instance.detecting.enable=false\n#canal.instance.detecting.sql=insert into retl.xdual values(1,now()) on duplicate key update x=now()\ncanal.instance.detecting.sql=select 1\ncanal.instance.detecting.interval.time=3\ncanal.instance.detecting.retry.threshold=3\ncanal.instance.detecting.heartbeatHaEnable=false\n\n# support maximum transaction size, more than the size of the transaction will be cut into multiple transactions delivery\ncanal.instance.transaction.size=1024\n# mysql fallback connected to new master should fallback times\ncanal.instance.fallbackIntervalInSeconds=60\n\n# network config\ncanal.instance.network.receiveBufferSize=16384\ncanal.instance.network.sendBufferSize=16384\ncanal.instance.network.soTimeout=30\n\n# binlog filter config\ncanal.instance.filter.druid.ddl=true\ncanal.instance.filter.query.dcl=false\ncanal.instance.filter.query.dml=false\ncanal.instance.filter.query.ddl=false\ncanal.instance.filter.table.error=false\ncanal.instance.filter.rows=false\ncanal.instance.filter.transaction.entry=false\n\n# binlog format/image check\ncanal.instance.binlog.format=ROW,STATEMENT,MIXED\ncanal.instance.binlog.image=FULL,MINIMAL,NOBLOB\n\n# binlog ddl isolation\ncanal.instance.get.ddl.isolation=false\n\n# parallel parser config\ncanal.instance.parser.parallel=true\n## concurrent thread number, default 60% available processors, suggest not to exceed Runtime.getRuntime().availableProcessors()\n#canal.instance.parser.parallelThreadSize=16\n## disruptor ringbuffer size, must be power of 2\ncanal.instance.parser.parallelBufferSize=256\n\n# table meta tsdb info\ncanal.instance.tsdb.enable=true\ncanal.instance.tsdb.dir=${canal.file.data.dir:../conf}/${canal.instance.destination:}\ncanal.instance.tsdb.url=jdbc:h2:${canal.instance.tsdb.dir}/h2;CACHE_SIZE=1000;MODE=MYSQL;\ncanal.instance.tsdb.dbUsername=canal\ncanal.instance.tsdb.dbPassword=canal\n# dump snapshot interval, default 24 hour\ncanal.instance.tsdb.snapshot.interval=24\n# purge snapshot expire , default 360 hour(15 days)\ncanal.instance.tsdb.snapshot.expire=360\n\n# aliyun ak/sk , support rds/mq\ncanal.aliyun.accessKey=\ncanal.aliyun.secretKey=\n\n#################################################\n######### 		destinations		#############\n#################################################\ncanal.destinations=\n# conf root dir\ncanal.conf.dir=../conf\n# auto scan instance dir add/remove and start/stop instance\ncanal.auto.scan=true\ncanal.auto.scan.interval=5\n\n#canal.instance.tsdb.spring.xml=classpath:spring/tsdb/h2-tsdb.xml\n#canal.instance.tsdb.spring.xml=classpath:spring/tsdb/mysql-tsdb.xml\n\ncanal.instance.global.mode=manager\ncanal.instance.global.lazy=false\ncanal.instance.global.manager.address=${canal.admin.manager}\n#canal.instance.global.spring.xml=classpath:spring/memory-instance.xml\n#canal.instance.global.spring.xml=classpath:spring/file-instance.xml\ncanal.instance.global.spring.xml=classpath:spring/default-instance.xml\n\n##################################################\n######### 		     MQ 		     #############\n##################################################\ncanal.mq.servers=127.0.0.1:6667\ncanal.mq.retries=0\ncanal.mq.batchSize=16384\ncanal.mq.maxRequestSize=1048576\ncanal.mq.lingerMs=100\ncanal.mq.bufferMemory=33554432\ncanal.mq.canalBatchSize=50\ncanal.mq.canalGetTimeout=100\ncanal.mq.flatMessage=true\ncanal.mq.compressionType=none\ncanal.mq.acks=all\n#canal.mq.properties=\ncanal.mq.producerGroup=test\n# Set this value to \"cloud\", if you want open message trace feature in aliyun.\ncanal.mq.accessChannel=local\n# aliyun mq namespace\n#canal.mq.namespace=\n\n##################################################\n#########     Kafka Kerberos Info    #############\n##################################################\ncanal.mq.kafka.kerberos.enable=false\ncanal.mq.kafka.kerberos.krb5FilePath=\"../conf/kerberos/krb5.conf\"\ncanal.mq.kafka.kerberos.jaasFilePath=\"../conf/kerberos/jaas.conf\"\n','37301a4438a3b59da37b84e5e4f8382f','2020-08-24 16:46:51'),
	(2,1,NULL,'application.yml',NULL,'server:\n  port: 8081\nspring:\n  jackson:\n    date-format: yyyy-MM-dd HH:mm:ss\n    time-zone: GMT+8\n    default-property-inclusion: non_null\n\ncanal.conf:\n  mode: tcp #tcp kafka rocketMQ rabbitMQ\n  flatMessage: true\n  zookeeperHosts:\n  syncBatchSize: 1000\n  retries: 0\n  timeout:\n  accessKey:\n  secretKey:\n  consumerProperties:\n    # canal tcp consumer\n    canal.tcp.server.host: 127.0.0.1:11111\n    canal.tcp.zookeeper.hosts:\n    canal.tcp.batch.size: 500\n    canal.tcp.username:\n    canal.tcp.password:\n    # kafka consumer\n    kafka.bootstrap.servers: 127.0.0.1:9092\n    kafka.enable.auto.commit: false\n    kafka.auto.commit.interval.ms: 1000\n    kafka.auto.offset.reset: latest\n    kafka.request.timeout.ms: 40000\n    kafka.session.timeout.ms: 30000\n    kafka.isolation.level: read_committed\n    kafka.max.poll.records: 1000\n    # rocketMQ consumer\n    rocketmq.namespace:\n    rocketmq.namesrv.addr: 127.0.0.1:9876\n    rocketmq.batch.size: 1000\n    rocketmq.enable.message.trace: false\n    rocketmq.customized.trace.topic:\n    rocketmq.access.channel:\n    rocketmq.subscribe.filter:\n    # rabbitMQ consumer\n    rabbitmq.host:\n    rabbitmq.virtual.host:\n    rabbitmq.username:\n    rabbitmq.password:\n    rabbitmq.resource.ownerId:\n\n#  srcDataSources:\n#    defaultDS:\n#      url: jdbc:mysql://127.0.0.1:3306/mytest?useUnicode=true\n#      username: root\n#      password: 121212\n  canalAdapters:\n  - instance: example01 # canal instance Name or mq topic name\n    groups:\n    - groupId: g1\n      outerAdapters:\n      - name: logger\n#      - name: rdb\n#        key: mysql1\n#        properties:\n#          jdbc.driverClassName: com.mysql.jdbc.Driver\n#          jdbc.url: jdbc:mysql://127.0.0.1:3306/mytest2?useUnicode=true\n#          jdbc.username: root\n#          jdbc.password: 121212\n#      - name: rdb\n#        key: oracle1\n#        properties:\n#          jdbc.driverClassName: oracle.jdbc.OracleDriver\n#          jdbc.url: jdbc:oracle:thin:@localhost:49161:XE\n#          jdbc.username: mytest\n#          jdbc.password: m121212\n#      - name: rdb\n#        key: postgres1\n#        properties:\n#          jdbc.driverClassName: org.postgresql.Driver\n#          jdbc.url: jdbc:postgresql://localhost:5432/postgres\n#          jdbc.username: postgres\n#          jdbc.password: 121212\n#          threads: 1\n#          commitSize: 3000\n#      - name: hbase\n#        properties:\n#          hbase.zookeeper.quorum: 127.0.0.1\n#          hbase.zookeeper.property.clientPort: 2181\n#          zookeeper.znode.parent: /hbase\n#      - name: es\n#        hosts: 127.0.0.1:9300 # 127.0.0.1:9200 for rest mode\n#        properties:\n#          mode: transport # or rest\n#          # security.auth: test:123456 #  only used for rest mode\n#          cluster.name: elasticsearch\n#        - name: kudu\n#          key: kudu\n#          properties:\n#            kudu.master.address: 127.0.0.1 # \',\' split multi address','dc82882ecf0ca6f2bdf7ab47c784c86c','2021-03-11 02:06:42');

/*!40000 ALTER TABLE `canal_config` ENABLE KEYS */;
UNLOCK TABLES;



/*!40111 SET SQL_NOTES=@OLD_SQL_NOTES */;
/*!40101 SET SQL_MODE=@OLD_SQL_MODE */;
/*!40014 SET FOREIGN_KEY_CHECKS=@OLD_FOREIGN_KEY_CHECKS */;
/*!40101 SET CHARACTER_SET_CLIENT=@OLD_CHARACTER_SET_CLIENT */;
/*!40101 SET CHARACTER_SET_RESULTS=@OLD_CHARACTER_SET_RESULTS */;
/*!40101 SET COLLATION_CONNECTION=@OLD_COLLATION_CONNECTION */;
