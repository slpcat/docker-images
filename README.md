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
代码审核: gerrit,crucible
代码品质管理: SonarQube(荐),revive,FindBugs,spotBugs,CodeQL,ShiftLeft inspect
代码安全扫描: Fortify SCA(Source Code Analysis),FindBugs Security Audit，Checkmarx CxSuite，Armonize CodeSecure，Flawfinder，CodeSonar，HP DevInspect，SecurityReview，腾讯TscanCode,Alerta,Contrast Assess,CodeAI,Parasoft,Veracode,IriusRisk,ThreatModeler,OWASP Threat Dragon,BDD-Security,Chef InSpec,Gauntlt,Synopsys,Aqua Security(荐),TwistLock,Dome9 Arc,RedLock,SD Elements,WhiteHat Sentinel ,WhiteSource,snyk.io,dagda,KubeXray,Falco,StackRox,Apcera
低代码开发: ivx.cn,wuyuan.io,Outsystems,Mendix,

Docker容器安全扫描:Grype,Trivy,
Phaistos KMS是一种非常易于操作，高性能，无状态的密钥和机密管理服务。
kubesec：Kubernetes的安全秘密管理（具有gpg，Google Cloud KMS和AWS KMS后端）

动态应用程序安全测试（DynamicApplication Security Testing）
Goby/Xray/Awvs/Nessus
Github监控平台-Hawkeye
Falco终端监控


编译器: numba,Emscripten
docker基础镜像源：webdevops，bitnami,turnkey,distroless

持续集成/发布: jenkins,jenkins-x,fabric8,spinnaker,gitlab-ci,drone,makisu,flagger(荐),shipper,Hubot,Lita,Err,StackStorm,Netflix Winston,Tekton,CDS,gaia,FlyWayDB,LiquiBase,Flocker,ArgoCD,
测试: chaos-monkey,chaoskube,k8s-testsuite,test-infra,sonobuoy,PowerfulSeal,twemperf(memcached),locust，selenium,Cucumber,LoadRunner,SoapUI,appium,espresso, robotium
混沌工程: kube-monkey,powerfulseal,chaostoolkit-kubernetes,ChaosMesh,Litmus Chaos
artifactory仓库: nexus2,nexus3,harbor,registry,quay,jfrog/Artifactory

CMDB资产配置: OneCMDB、CMDBuild、ItopCMDB、Rapid OSS、ECDB、i-doit、iTop
开源DevOps平台: walle,gaia,BlueKing-cmdb,cds,cloudunit,hygieia,adminset
跳板机/堡垒机: jumpserver,Guacamole 是一个基于 HTML 5 和 JavaScript 的 VNC 查看器，服务端基于 Java 的 VNC-to-XML 代理开发。
helm应用商店: chartmuseum,kubeapps
分布式存储: ceph,minio,openebs,glusterfs,EdgeFS,moosefs,lizardfs,beegfs,iomesh,rancher longhorn,
分布式数据库:citusdata,tidb,OceanBase
内存分布式管理系统: Alluxio,apache ignite,Apache arrow,Hazelcast,Oracle Coherence,GemFire
大数据集群: hadoop(hdfs+yarn),hbase,spark,flink,Drill
实时流计算: Spark （micro batch），Storm， Flink，Samza,Kafka Stream,StreamBase,Hangout,Amazon Kinesis,Apache Ignite
ETL/CDC工具: DataX,DataX Web,Kettle,Sqoop,streamSets,Apache NiFi,Kafka Connect,Debezium(荐),Waterdrop,databus,canal,maxwell,mysql_steamer,flinkx,datalink,
web服务器/容器: nginx-php,apache-php,tomcat,resin
java虚拟机: graalvm,sdkman
SQL数据库: mysql,percona,mariadb,postgresql,greenplum,MyRocks,Citus,mssql-linux
SQL版本管理: Flyway
SQL审计: Yearning MYSQL(荐),Inception，SQL审核-goinception,mysql-sniffer，pgAudit
mysql管理工具: Induction,Pinba,DB Ninja,DB Tools Manager,Dbeaver,SqlWave,MyWebSQL,Navicat,SQLyog,Sequel Pro,HeidiSQL,MyDB Studio,SQL Lite Manger,Database Master,Chive,phpMyAdmin
Mongodb管理工具: Robo 3T/Robomongo,Navicat for MongoDB,MongoDB Compass 社区版,MongoBooster,Cluster control,NOSQLCLIENT,Mongo Management Studio,phpMoAdmin,Mongotron,Mongolime,Mongo-express,
MPP DataBase: Teradata,Greenplum,Vertica,Impala,GPDB
数据库中间件: proxySQL,ShardingSphere,MyCat,Vitess
数据可视化: Superset,SQLPad,MetaBase,Franchise,Redash,ECharts,mapd-charting,highchart,d3.js,google chart,gephi,Sigma.js,Keylines,VivaGraph,ngraph,Linkurious,immerse,Mapv,deck.gl,DbVisualizer
NoSQL数据库/缓存/存储: memcache,rethinkdb,redis,ssdb,leveldb,mongodb,cassandra,ScyllaDB,LucidDB,boltdb,ArangoDB,Azure DocumentDB,DynamoDB,Hazelcast,Infinispan,MarkLogic,OrientDB,OnceDB,TerarkDB
分布式kv存储: 小米Pegasus,Zeppelin,京东JIMDB，淘宝Tair，tikv
列式数据库: clickhouse(荐),Vertica,MonetDB,InfiniDB,ParAccel,EventQL,HadoopDB,Postgres-XL,RecDB,Stado,Yahoo Everest,DorisDB,Apache Doris
图数据库: AgensGraph,Titan/JanusGraph,neo4j,OrientDB,FlockDB,Arangodb,GunDB,TigerGraph,LightGraphs,PandaGraph,Cayley,Orly,DGraph,SparkGraphX,InfiniteGraph,
数据仓库: Infobright,Palo,Druid,pinot,Kylin,Hyper,presto，argo
GPU-Powered Database: Kinetica,OmniSciDB (formerly MapD Core),BlazingDB,Brytlyt,PG-Strom,Blazegraph,SQream
NewSQL数据库: TiDB,cockroachdb,VoltDB,Clustrix, NuoDB,TokuDB, MemSQL,Couchbase,CouchDB,Riak,postgres-xl, antdb, citusDB, Greenplum,yugabytedb,CrateDB
API查询语言: GraphQL,prisma.io
API管理和测试: API Fortress,MockApi,APIJSON,Postman,Tyk,Swagger,RAP2,YApi,Eolinker,DOClever,Apizza,EasyAPI,CrapApi,apidoc,swagger
时间序列数据库: influxdb,opentsdb,m3db,Heroic,TimeScaleDB,KairosDB,DolphinDB,TDengine,Druid,Graphite,pipelinedb,VictoriaMetrics,MatrixDB,IoTDB
Event Streaming Database: ksqlDB,
消息队列/流存储: rabbitmq,zeromq,memcacheq,rocketmq,pulsar,rocketmq-console-ng,kafka,kafka-manager,nsq,nats
配置管理: zookeeper,zkui,qconf,etcd,apollo,disconf,spring-cloud-config,nacos,stakater/Reloader,ConfigmapController
定时/任务管理: xxl-job,elasticjob,escalator,cronsun,
聊天软件: Discourse,RocketChat,slack,Telegram,HipChat,
培训管理: Canvas LMS,
业务流程管理（BPM): Activiti,Alfresco,SnakerFlow
门户平台: eXo Platform,
自动化运维: puppet,cfengine,saltstack,SaltGUI,ansible,Ansible AWX,Anisble Tower,VictorOps,OpsGenie,PagerDuty,Pushover
集群管理: nomad,pke,rke,pipeline
项目管理: jira,zentao,Redmine,Taiga,OpenProject,DotProject,Orangescrum,Bugzilla
企业ERP: odoo,ADempiere,Apache OFBiz,Dolibarr,ERPNext,Metasfresh,Opentaps,WebERP,xTuple PostBooks
开发环境SDK: golang,golang-gvm,oracle-jdk,oracle-jdk-maven
配置管理与服务自动发现: consul,confd,containerpilot,registrator
微服务管理与持续发布: fabric8,jenkins-x,draft,knative,service-fabric
API网关/反向代理/ingress: kong,konga,kong-dashboard,fabio,traefik,envoy,Apache APISIX
微服务框架/组件: istio,naftis,dubbo,dubbokeeper,consul,openlambda,linkerd2/Conduit,registrator,Containous,Maesh,Backyards,SOFAMesh,kuma,nameko,gokit.io,netramesh,solo.io,dapr
流媒体服务器: SRS(荐),Licode,Jitsi,Kurento,mediasoup,Janus,red5pro,Ant-Media-Server,Asterisk,FreeSWITCH, RestComm,BigBlueButton,NextRTC,OpenBroadcaster,livekit.io,jellyfin
QUIC服务端: caddy,快手kQUIC,nginx-quic,
直播服务器：SRS，jitsi，kurento，mediasoup,janus,licode,red5pro,ant-media-server,OpenVidu,

FAAS: fission,fnproject,funktion,kubeless,nuclio,open-lambda,openfaas,openwhisk,vmware-dispatch,Claudia
日志集群: elastic-stack(elasticsearch+cerebro+kibana),Elassandra,sonic,grafana-loki,splunk,graylog
日志采集: logstash,filebeat,logtail,log-pilot,logspout,auditbeat,hangout,fluentd,fluent-bit,loki/promtail,vector
监控: Argus,bosun,Collectd,cadvisor,cortex,heapster,kube-state-metrics,metrics-server,searchlight,prometheus,thanos,kubewatch,searchlight,Molten,sensu,telegraf(TICK),Alerta,zabbix,statsite,statsd,riemann, Wavefront,Honeycomb,Graphite,open-falcon,Xhprof/Xhgui,nightingale,CAT（Central Application Tracking）,netdata,LEPUS天兔(专用于监控数据库)
商业监控:监控宝，监控易，听云，
动态性能追踪: bcc-tools,systemtap,sysdig,kubectl-trace,bpftrace
APM/tracing: appdash,apm-server,pinpoint,jaeger,zipkin,skywalking,opentracing,opencensus,opentelemetry,Elastic APM(原Opbeat),Dapper(Google),StackDriver Trace (Google),鹰眼(taobao),谛听(盘古，阿里云云产品使用的Trace系统),云图(蚂蚁Trace系统),X-ray(aws),Datadog,AppDynamics,New Relic,ScienceLogic,SignalFx,Stackifya,Dynatrace,OneAPM,RichAPM,Instana,RapidSpike,IQLECT,Dynatrace,SolarWinds Server & Application Monitor,CloudMonix,Glowroot,2 Steps,inspectIT,Tempo,SigNoz,
基础架构即代码: packer,terraform
分布式事务: seata,EasyTransaction

kubernetes集群安装/升级: kubespray
Kubernetes发行版: Rancher,CoreOS Tectonic,Canonical Distribution of Kubernetes（CDK）,Heptio Kubernetes,Kontena Pharos,Pivotal 容器服务 (PKS),Red Hat OpenShift,Telekube,Microk8s,k3s,
kubernetes可视化管理工具: kubernetes-dashboard,weavescope,kubebox,kubedash,kube-ops-view,cabin,wayne(360),KubeSphere,openshift,rancher,Kuboard,lensapp/lens,karbon,instana
kubernetes灾难恢复: ark/Velero,Velero/etcd,
sealer[ˈsiːlər]是一款分布式应用打包交付运行的解决方案，通过把分布式应用及其数据库中间件等依赖一起打包以解决复杂应用的交付问题。
kubernetes扩容:virtual-kubelet,cluster-capacity,hpa-operator
kubernetes集群事件采集: kube-eventer(荐),kube-eventrouter,kubernetes-event-exporter
kubernetes成本计算: Kubecost
kubernetes配置导出: neat
KubeVela 是一个简单易用且高度可扩展的应用管理平台与核心引擎。KubeVela 是基于 Kubernetes 与 OAM 技术构建的。
CIS 安全基线:open-scap
Paralus: 零信任安全
NeuVector：业内首个开源容器安全平台
kubernetes边缘计算: KubeEdge+Sedna,StarlingX、K3s、EdgeXfoundry、EdgeGallery、Akraino、Baetyl、OpenYurt、SuperEdge、Azure IoT Edge,superedge

Datree Kubernetes 配置检测 CLI 工具
Terrascan Terrascan是一种基础架构即代码静态代码分析器，是一种用于扫描基础架构即代码以查找安全漏洞的工具。您可以无缝地将基础设施扫描为代码。
kube-bench 评估部署的集群以确保遵守所有最佳安全实践并且没有漏洞。该工具可以使用多种方法进行评估
除了安全评估之外，ARMO 的 Kubescape 还进行合规性评估。检查正在运行的集群的 YAML 文件，以便在配置错误漏洞变得致命之前及早在 CI/CD 管道中检测到。它不仅与 MITRE NSA-CISA 等各种知名框架兼容，而且还提供了开发自定义合规模板的能力，这些模板满足合规标准的所有特定要求。
KubeClarity is a tool for detection and management of Software Bill Of Materials (SBOM) and vulnerabilities of container images and filesystems. It scans both runtime K8s clusters and CI/CD pipelines for enhanced software supply chain security.

Open Application Model （OAM)
https://openappmodel.io

微服务Protocol: RSocket

ReactiveX
http://reactivex.io/

开发工具: Telepresence,Keel,Apollo,Deis Workflow,Kel,
安全工具: anchore,clair,cert-manager,docker-bench-security,magic-namespace,notary,OpenSCAP,trireme,NeuVector,Deepfence,StackRox,Tenable,Cavirin,Kube-Bench,Sysdig Falco,Sysdig Secure,Kubesec.io;付费 Aquasec,flawcheck,portshift-operator,bane apparmor,
安全平台: Wazuh,
安全审计: Auditbeat+ELK,
编排转换：kompose
云管理软件(CMP): ManageIQ/CloudForms,腾讯蓝鲸(BlueKing),CODO,VMware vRealize Suite,AbiCloudi/Abiquo,Micro Focus,Scalr,RackSpace,RightCloud,RightScale,SaCa Aclome,新浪DCP,Cloudify,Mist.io,VirtEngine,openQRM,OpenNebula,Eucalyptus,天云SkyForm CMP,ZStack CMP,博云BeyondCMP,Cisco InterCloud,骞云SmartCMP,飞致云FIT2CLOUD,云霁CloudRes,浪潮OpsNow,行云管家,新钛云服TiOps,华讯CloudEagle，神州SmartCOP，九州云Animbus CMP，海云捷迅AWCloud，IBM MCMP,IBM Cloud Management，深信服云管平台,OpenNebula,Cloudability,Cloudyn Cloud Management,Dell Cloud Manager v11,BMC Cloud Management,HP Hybrid Cloud Management,CSC Agility Platform,优维EasyOps,BigOps,openpitrix
云平台:OpenStack、CloudStack、Hadoop、Apache Mesos、基于Docker的kubernetes、swarm，微软System Center，AzureStack,EasyStack,CloudFoundry,CBSD,CacheCloud(redis)

备份/恢复/迁移: mydumper,zkcopy,mongodb_consistent_backup, WAL-E,Bacula/baculum,Backupninja,amanda,Backuppc,UrBackup,restic,veleo
PaaS:flynn,tsuru,service-catalog
负载均衡: gimbal,metallb,porter,GLB Director,DPDK-LVS,Jupiter,Seesaw,LoadMaster by KEMP,HAProxy,Zevenet,PEN,Gobetween,Kube-Vip
Routing: quagga,frr(荐),Zebra, bird, bgpd,flexiwan,openwrt,
大数据集群管理: CDH,HDP,ambari
商业智能BI: MS Power BI,Superset,Metabase,CBoard,JasperSoft, OpenReports,SpagoBI,Pentaho,knowage-suite,Helical Insight,Knime,Rapidminer,Reportserver,Seal Report,Spagobi,SQL Power Wabit,Tableau Public,Zoho Reports,QlikView,SAP Business Objects,IBM Cognos Analytics, Oracle Business Intelligence,Yellowfin,WebFOCUS,TIBCO Spotfire,SAS BI,Targit,Izenda Embedded BI & Analytics,MicroStrategy,Board,Sisense, Statsbot,Panorama-Necto,InetSoft,FineBI,BIRT,Jupyter Notebook,zeppelin,metabase
数据报表
数据分析
数据挖掘
https://github.com/thenaturalist/awesome-business-intelligence

物联网开源平台: FIWARE
机器学习: OpenNLP,Theano,Lasagne,TensorFlow,Keras,MXNet,PyTorch,Caffe,CNTK,Neon,arena

边缘计算平台
EdgeXFoundry,ApacheEdgent,CORD,Akraino EdgeStack,AWSGreengrass ,Azure IoT Edge,

蜜罐软件: Honeyd,Nepenthes,Honeytrap,HoneyBot,Opencanary,Kippo,T-Pot,Dionaea,MHN(Modern Honey Network),Conpot,HoneyDrive

observability-as-code

PXE装机: fai-project,Cobbler,kickstart
集群pod调试: kubectl-debug

https://github.com/soutong/security_w1k1

kubernetes插件/增强: node-feature-discovery
GPU计算: gpushare-device-plugin,gpushare-scheduler-extender,NVIDIA GPU Operator

云原生（CloudNative）应用
分布式存储: rook-ceph,rook-minio,openebs
虚拟化: kubevirt(荐),virtlet,rancher/vm,Harvester
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
https://github.com/lyft/flinkk8soperator
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
thanos-operator
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

kafka-operator: Banzai Cloud/koperator(荐),Krallistic,Strimzi,Confluent

https://commons.openshift.org/sig/operators.html

开源协作办公: OwnCloud Documents,OnlyOffice,ResourceSpace,Pydio

https://www.cisecurity.org/benchmark/kubernetes/

https://github.com/dev-sec/cis-kubernetes-benchmark

https://github.com/coinbase/salus

桌面服务(DaaS)
ubuntu-xfce-vnc
ubuntu-icewm-vnc
centos-xfce-vnc
centos-icewm-vnc
x11docker
xrdp
teamviewer
anydesk

Docker-OSX

数据库服务(DBaaS)
mysql
redis

可视应用平台DVAAS（Data Visualization as a Service）
device plugin framework
Graphics Processing Unit (GPU) plugin
Field Programmable Gate Array (FPGA) plugin
Intel® QuickAssist Technology (QAT) plugin

基于Kubernetes的容器和云计算操作系统
https://banzaicloud.com/

基于Kubernetes容器编排平台的安全平台
Portshift

开发原则和模式
云原生规范 Cloud Native Definition
https://github.com/cncf/toc/blob/master/DEFINITION.md
微服务十二要素 The Twelve Factors
https://12factor.net/

不可变基础设施
容器root不可写，普通用户权限运行，仅仅写入volume


常用linux软件
钉钉
https://dtapp-pub.dingtalk.com/dingtalk-desktop/xc_dingtalk_update/linux_deb/Release/com.alibabainc.dingtalk_1.0.0.203_amd64.deb
百度网盘
https://www.ubuntukylin.com/public/pdf/baidunetdisk_linux_2.0.1-2_amd64.deb

