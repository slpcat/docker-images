常用docker容器镜像构建，kubernetes配置文件，helm模板,用于搭建基于容器的可控云计算基础设施,包括物理机裸机，虚拟机，多厂商云主机，有效规避云计算厂商锁定

kubernetes网络方案在条件允许的情况下，推荐尽量使用kube-router+cilium,支持bgp路由、ipvlan以及eBPF引擎,对clustermesh、servicemesh以及宿主机网络集成更好的支持。推荐使用Cilium替换Kube-proxy.

默认采用的网络与存储是完全软件方案，在不投入硬件的前提下尽量高的性能和稳定性。

硬件方案推荐FPGA。

容器内核参数已经为高并发大吞吐量低延迟场景优化，完美运行需要kubernetes版本>=v1.15和内核版本>=4.19.

内核特性需求：
容器sysctl配置需要内核版本>=4.15

ipvlan需要内核版本>=4.19

低版本内核需要删除sysctl相关配置，这样做会失去单实例高并发能力。


宿主机系统推荐使用ubuntu或者debian并且启用apparmor enforce模式，有效对抗容器逃脱。有能力的可以部署grsecurity内核进一步增强安全,全面对抗0day漏洞。如果使用centos7 需要更新内核。

支持在kubernetes集群里面运行Linux桌面环境(暂无3D加速)
如果需要基于虚拟化的隔离，使用kata-container


代码仓库: gitlab-ce,gogs
代码审核: gerrit
编译器: numba
docker基础镜像源：webdevops，bitnami,turnkey,distroless
持续集成/发布: jenkins,jenkins-x,fabric8,spinnaker,gitlab-ci,drone,makisu,flagger,shipper,Hubot,Lita,Err,StackStorm,Netflix Winston
测试: chaos-monkey,chaoskube,k8s-testsuite,test-infra,sonobuoy,PowerfulSeal,twemperf(memcached),locust，selenium
artifactory仓库: nexus2,nexus3,harbor,registry,quay
helm应用商店: chartmuseum,kubeapps
分布式存储: ceph,minio,openebs,glusterfs,EdgeFS
大数据集群: hadoop(hdfs+yarn),hbase,spark,flink,Drill
实时流计算: Spark （micro batch），Storm， Flink，Samza,Kafka Stream,StreamBase,Hangout,Amazon Kinesis,Apache Ignite
ETL/CDC工具: DataX,Kettle,Sqoop,streamSets,Apache NiFi,Kafka Connect,Debezium,Waterdrop,databus,canal
web服务器/容器: nginx-php,apache-php,tomcat,resin
SQL数据库: mysql,percona,mariadb,postgresql,greenplum,MyRocks,Citus,mssql-linux
SQL版本管理: Flyway
SQL审计: Yearning MYSQL,Inception，mysql-sniffer，pgAudit
mysql管理工具: Induction,Pinba,DB Ninja,DB Tools Manager,Dbeaver,SqlWave,MyWebSQL,Navicat,SQLyog,Sequel Pro,HeidiSQL,MyDB Studio,SQL Lite Manger,Database Master,Chive,phpMyAdmin
Mongodb管理工具: Robo 3T/Robomongo,Navicat for MongoDB,MongoDB Compass 社区版,MongoBooster,Cluster control,NOSQLCLIENT,Mongo Management Studio,phpMoAdmin,Mongotron,Mongolime,Mongo-express,
MPP DataBase: Teradata,Greenplum,Vertica,Impala,GPDB
数据库中间件: proxySQL,ShardingSphere,MyCat,Vitess
数据可视化: Superset,SQLPad,MetaBase,Franchise,Redash,ECharts,mapd-charting,highchart,d3.js,google chart,gephi,Sigma.js,Keylines,VivaGraph,ngraph,Linkurious,immerse,Mapv,deck.gl,DbVisualizer
NoSQL数据库/缓存/存储: memcache,rethinkdb,redis,ssdb,leveldb,mongodb,cassandra,ScyllaDB,LucidDB,boltdb,ArangoDB,Azure DocumentDB,DynamoDB,Hazelcast,Infinispan,MarkLogic,OrientDB,OnceDB
列式数据库: clickhouse(荐),Vertica,MonetDB,InfiniDB,ParAccel,EventQL,HadoopDB,Postgres-XL,RecDB,Stado,Yahoo Everest,
图数据库: AgensGraph,Titan/JanusGraph,neo4j,OrientDB,FlockDB,Arangodb,GunDB,TigerGraph,LightGraphs,PandaGraph,Cayley,Orly,DGraph,SparkGraphX,InfiniteGraph,
数据仓库: Infobright,Palo,Druid,pinot,Kylin,Hyper,presto，argo
GPU-Powered Database: Kinetica,OmniSciDB (formerly MapD Core),BlazingDB,Brytlyt,PG-Strom,Blazegraph,SQream
NewSQL数据库: TiDB,cockroachdb,VoltDB,Clustrix, NuoDB,TokuDB, MemSQL,Couchbase,CouchDB,Riak,postgres-xl, antdb, citusDB, Greenplum,yugabytedb
API查询语言: GraphQL,prisma.io
API管理和测试: API Fortress,MockApi,APIJSON,Postman,Tyk,Swagger,RAP2,YApi,Eolinker,DOClever,Apizza,EasyAPI,CrapApi,apidoc,swagger
时间序列数据库: influxdb,opentsdb,m3db,Heroic,TimeScaleDB,KairosDB,DolphinDB,Druid,Graphite,pipelinedb
消息队列/流存储: rabbitmq,zeromq,memcacheq,rocketmq,pulsar,rocketmq-console-ng,kafka,kafka-manager
配置管理: zookeeper,zkui,qconf,etcd,apollo,disconf,spring-cloud-config,nacos
定时/任务管理: xxl-job,elasticjob,escalator
聊天软件: Discourse,RocketChat
培训管理: Canvas LMS,
代码品质管理: SonarQube
门户平台: eXo Platform,
自动化运维: puppet,cfengine,saltstack,SaltGUI,ansible,Ansible AWX,Anisble Tower
集群管理: nomad,pke,rke,pipeline
项目管理: jira,zentao,Redmine,Taiga,OpenProject,DotProject,Orangescrum,Bugzilla
企业ERP: odoo,ADempiere,Apache OFBiz,Dolibarr,ERPNext,Metasfresh,Opentaps,WebERP,xTuple PostBooks
开发环境SDK: golang,golang-gvm,oracle-jdk,oracle-jdk-maven
配置管理与服务自动发现: consul,confd,containerpilot,registrator
微服务管理与持续发布: fabric8,jenkins-x,draft,knative,service-fabric
API网关/反向代理/ingress: kong,konga,kong-dashboard,fabio,traefik,envoy,Apache APISIX
微服务框架/组件: istio,naftis,dubbo,dubbokeeper,consul,openlambda,linkerd2/Conduit,registrator,Containous,Maesh,Backyards,SOFAMesh,kuma,nameko,

FAAS: fission,fnproject,funktion,kubeless,nuclio,open-lambda,openfaas,openwhisk,vmware-dispatch,Claudia
日志集群: elastic-stack(elasticsearch+cerebro+kibana),Elassandra
日志采集: logstash,filebeat,logtail,log-pilot,logspout,auditbeat,hangout
监控: ,Argus,bosun,cadvisor,cortex,heapster,kube-state-metrics,metrics-server,searchlight,prometheus,thanos,kubewatch,searchlight,Molten,sensu,telegraf,zabbix,Honeycomb,Graphite,open-falcon,Xhprof/Xhgui,nightingale,CAT（Central Application Tracking）
动态性能追踪: bcc-tools,systemtap,sysdig
APM/tracing: appdash,apm-server,pinpoint,jaeger,zipkin,skywalking,opentracing,opencensus,opentelemetry,Elastic APM(原Opbeat),Dapper(Google),StackDriver Trace (Google),鹰眼(taobao),谛听(盘古，阿里云云产品使用的Trace系统),云图(蚂蚁Trace系统),X-ray(aws),Datadog,AppDynamics,New Relic,ScienceLogic,SignalFx,Stackifya,Dynatrace,OneAPM,RichAPM,
kubernetes集群安装/升级: kubespray
Kubernetes发行版: Rancher,CoreOS Tectonic,Canonical Distribution of Kubernetes（CDK）,Heptio Kubernetes,Kontena Pharos,Pivotal 容器服务 (PKS),Red Hat OpenShift,Telekube,Microk8s,k3s,
kubernetes可视化管理工具: kubernetes-dashboard,weavescope,kubebox,kubedash,kube-ops-view,cabin,wayne(360),KubeSphere,openshift,rancher
kubernetes灾难恢复: ark
kubernetes扩容:virtual-kubelet,cluster-capacity,hpa-operator
开发工具: Telepresence,Keel,Apollo,Deis Workflow,Kel,
安全工具: anchore,clair,cert-manager,docker-bench-security,magic-namespace,notary,OpenSCAP,trireme,NeuVector,Deepfence,StackRox,Tenable,Cavirin,Kube-Bench,Sysdig Falco,Sysdig Secure,Kubesec.io;付费 Aquasec,flawcheck
编排转换：kompose
云管理软件(CMP): ManageIQ/CloudForms,腾讯蓝鲸(BlueKing),CODO,VMware vRealize Suite,AbiCloudi/Abiquo,Micro Focus,Scalr,RackSpace,RightCloud,RightScale,SaCa Aclome,新浪DCP,Cloudify,Mist.io,VirtEngine,openQRM,OpenNebula,Eucalyptus,天云SkyForm CMP,ZStack CMP,博云BeyondCMP,Cisco InterCloud,骞云SmartCMP,飞致云FIT2CLOUD,云霁CloudRes,浪潮OpsNow,行云管家,新钛云服TiOps,华讯CloudEagle，神州SmartCOP，九州云Animbus CMP，海云捷迅AWCloud，IBM MCMP,IBM Cloud Management，深信服云管平台,OpenNebula,Cloudability,Cloudyn Cloud Management,Dell Cloud Manager v11,BMC Cloud Management,HP Hybrid Cloud Management,CSC Agility Platform,优维EasyOps,
云平台:OpenStack、CloudStack、Hadoop、Apache Mesos、基于Docker的kubernetes、swarm，微软System Center，AzureStack,EasyStack,CloudFoundry,CBSD,CacheCloud(redis)

备份/恢复/迁移: mydumper,zkcopy,mongodb_consistent_backup, WAL-E
PaaS:flynn,tsuru,service-catalog
负载均衡: gimbal,metallb,porter,GLB Director,DPDK-LVS,Jupiter,Seesaw,LoadMaster by KEMP,HAProxy,Zevenet,PEN,Gobetween
Routing: quagga,frr(荐),Zebra, bird, bgpd
大数据集群管理: CDH,HDP,ambari
商业智能BI: MS Power BI,Superset,Metabase,CBoard,JasperSoft, OpenReports,SpagoBI,Pentaho,knowage-suite,Helical Insight,Knime,Rapidminer,Reportserver,Seal Report,Spagobi,SQL Power Wabit,Tableau Public,Zoho Reports,QlikView,SAP Business Objects,IBM Cognos Analytics, Oracle Business Intelligence,Yellowfin,WebFOCUS,TIBCO Spotfire,SAS BI,Targit,Izenda Embedded BI & Analytics,MicroStrategy,Board,Sisense, Statsbot,Panorama-Necto,InetSoft,FineBI,BIRT,Jupyter Notebook,zeppelin,
数据报表
数据分析
数据挖掘
https://github.com/thenaturalist/awesome-business-intelligence

物联网开源平台: FIWARE
机器学习: OpenNLP,Theano,Lasagne,TensorFlow,Keras,MXNet,PyTorch,Caffe,CNTK,Neon,arena

蜜罐软件: Honeyd,Nepenthes,Honeytrap,HoneyBot,Opencanary,Kippo,T-Pot,Dionaea,MHN(Modern Honey Network),Conpot,HoneyDrive

PXE装机: fai-project,Cobbler,kickstart
集群pod调试: kubectl-debug

kubernetes插件/增强: node-feature-discovery
GPU计算: gpushare-device-plugin,gpushare-scheduler-extender,NVIDIA GPU Operator

云原生（CloudNative）应用
分布式存储: rook-ceph,rook-minio,openebs
虚拟化: kubevirt
监控: prometheus-operator,jaeger-operator
配置管理: etcd-operator
operator-sdk
https://github.com/operator-framework
https://github.com/operator-framework/awesome-operators
https://operatorhub.io/

clickhouse-operator

NVIDIA GPU Operator
rook-operator
flinkk8soperator
istio-operator
influxdb-operator
grafana-operator
gitlab-operator
jaeger-operator
jenkins-operator
logging-operator
kong-operator
m3db-operator
minio-operator
https://github.com/banzaicloud/logging-operator
nexus-operator
openebs-operator
redis-operator
huanwei/rocketmq-operator
apache/rocketmq-operator
percona-xtradb-cluster-operator PXC 集群进行部署、管理、扩容及缩容
banzaicloud-mysql-operator
oracle-mysql-operator
presslabs-mysql-operator
percona-server-mongodb-operator
mongodb-enterprise-kubernetes
storageos-cluster-operator
spinnaker-operator
pulsar-operator

tensorflow-operator
tidb-operator
zookeeper-operator

cassandra-operator

kubedb(elasticsearch,memcached,mongodb,mysql,postgres,redis)

Kubestack(elasticsearch,etcd,memcached,postgresql,prometheus)

kafka-operator: Banzai Cloud(荐),Krallistic,Strimzi,Confluent

https://commons.openshift.org/sig/operators.html

开源协作办公: OwnCloud Documents,OnlyOffice,ResourceSpace,Pydio

桌面服务(DaaS)
ubuntu-xfce-vnc
ubuntu-icewm-vnc
centos-xfce-vnc
centos-icewm-vnc
x11docker
teamviewer
anydesk

数据库服务(DBaaS)
mysql
redis

可视应用平台DVAAS（Data Visualization as a Service）
device plugin framework
Graphics Processing Unit (GPU) plugin
Field Programmable Gate Array (FPGA) plugin
Intel® QuickAssist Technology (QAT) plugin

开发原则和模式
云原生规范 Cloud Native Definition
https://github.com/cncf/toc/blob/master/DEFINITION.md
微服务十二要素 The Twelve Factors
https://12factor.net/
