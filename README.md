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

Koji 构建系统 是 Fedora 的 RPM 构建系统。打包人员需要使用 koji 客户端来请求构建包，并获得构建系统返回的相关信息。Koji 运行在 Mock 之上来构建不同架构的 RPM 包，并确保它们正确构建。服务自身包含多个架构的几十台在线构建宿主机。

编译器: numba,Emscripten
docker基础镜像源：webdevops，bitnami,turnkey,distroless

持续集成/发布: jenkins,jenkins-x,fabric8,spinnaker,gitlab-ci,drone,makisu,flagger(荐),shipper,Hubot,Lita,Err,StackStorm,Netflix Winston,Tekton,CDS,gaia,FlyWayDB,LiquiBase,Flocker,ArgoCD,
测试: chaos-monkey,chaoskube,k8s-testsuite,test-infra,sonobuoy,PowerfulSeal,twemperf(memcached),locust，selenium,Cucumber,LoadRunner,SoapUI,appium,espresso, robotium
混沌工程: kube-monkey,powerfulseal,chaostoolkit-kubernetes,ChaosMesh,Litmus Chaos
artifactory仓库: nexus2,nexus3,harbor,registry,quay,jfrog/Artifactory
image-syncer 的定位是一个简单、易用的批量镜像迁移/同步工具，支持几乎所有目前主流的基于 docker registry V2 搭建的镜像存储服务
docker-mirror：神奇指令，一键把镜像拉回“家”

CMDB资产配置: OneCMDB、CMDBuild、ItopCMDB、Rapid OSS、ECDB、i-doit、iTop
开源DevOps平台: walle,gaia,BlueKing-cmdb,cds,cloudunit,hygieia,adminset
跳板机/堡垒机: jumpserver,Guacamole 是一个基于 HTML 5 和 JavaScript 的 VNC 查看器，服务端基于 Java 的 VNC-to-XML 代理开发。
helm应用商店: chartmuseum,kubeapps
分布式存储: ceph,minio,openebs,glusterfs,EdgeFS,moosefs,lizardfs,beegfs,iomesh,rancher longhorn,CubeFS
NVMesh: 100% Software Defined Storage with Maximum Efficiency
https://github.com/OpenMPDK/SMDK

JuiceFS 是一款面向云原生设计的高性能共享文件系统
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
Mongodb管理工具: Robo 3T/Robomongo(荐),Navicat for MongoDB,MongoDB Compass 社区版,MongoBooster,Cluster control,NOSQLCLIENT,Mongo Management Studio,phpMoAdmin,Mongotron,Mongolime,Mongo-express,
MPP DataBase: Teradata,Greenplum,Vertica,Impala,GPDB
数据库中间件: proxySQL,ShardingSphere,MyCat,Vitess
数据可视化: Superset,SQLPad,MetaBase,Franchise,Redash,ECharts,mapd-charting,highchart,d3.js,google chart,gephi,Sigma.js,Keylines,VivaGraph,ngraph,Linkurious,immerse,Mapv,deck.gl,DbVisualizer
NoSQL数据库/缓存/存储: memcache,rethinkdb,redis,ssdb,leveldb,mongodb,cassandra,ScyllaDB,LucidDB,boltdb,ArangoDB,Azure DocumentDB,DynamoDB,Hazelcast,Infinispan,MarkLogic,OrientDB,OnceDB,TerarkDB
redis GUI: redisInsight,RedisPlus,AnotherRedisDesktopManager,medis,redis desktop manager,Tiny RDM（Tiny Redis Desktop Manager）
分布式kv存储: 小米Pegasus,Zeppelin,京东JIMDB，淘宝Tair，tikv
列式数据库: clickhouse(荐),Vertica,MonetDB,InfiniDB,ParAccel,EventQL,HadoopDB,Postgres-XL,RecDB,Stado,Yahoo Everest,DorisDB,Apache Doris
图数据库: AgensGraph,Titan/JanusGraph,neo4j,OrientDB,FlockDB,Arangodb,GunDB,TigerGraph,LightGraphs,PandaGraph,Cayley,Orly,DGraph,SparkGraphX,InfiniteGraph,
数据仓库: Infobright,Palo,Druid,pinot,Kylin,Hyper,presto，argo,rockset,duckdb
GPU-Powered Database: Kinetica,OmniSciDB (formerly MapD Core),BlazingDB,Brytlyt,PG-Strom,Blazegraph,SQream
NewSQL数据库: TiDB,cockroachdb,VoltDB,Clustrix, NuoDB,TokuDB, MemSQL,Couchbase,CouchDB,Riak,postgres-xl, antdb, citusDB, Greenplum,yugabytedb,CrateDB
API查询语言: GraphQL,prisma.io
API管理和测试: API Fortress,MockApi,APIJSON,Postman,Tyk,Swagger,RAP2,RAP-API管理面板,YApi,Eolinker,DOClever,Apizza,EasyAPI,CrapApi,apidoc,swagger
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
流媒体服务器: SRS(荐),Licode,Jitsi,Kurento,mediasoup,Janus,red5pro,Ant-Media-Server,Asterisk,FreeSWITCH, RestComm,BigBlueButton,NextRTC,OpenBroadcaster,livekit.io,jellyfin,Plex 是一款开源客户端服务器媒体服务器
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
OpenTofu 是一个开源的基础设施即代码（IaC）框架，被提出作为 Terraform 的替代方案，并由 Linux 基金会管理。
分布式事务: seata,EasyTransaction

kubernetes集群安装/升级: kubespray
Kubernetes发行版: Rancher,CoreOS Tectonic,Canonical Distribution of Kubernetes（CDK）,Heptio Kubernetes,Kontena Pharos,Pivotal 容器服务 (PKS),Red Hat OpenShift,Telekube,Microk8s,k3s,
kubernetes可视化管理工具: kubernetes-dashboard,weavescope,kubebox,kubedash,kube-ops-view,cabin,wayne(360),KubeSphere,openshift,rancher,Kuboard,lensapp/lens,karbon,instana
Talos 是一个非常精简的操作系统，用 Golang 编写。Talos 被设计为一个特定于操作系统的操作系统，用于维护 Kubernetes 集群。
kubernetes灾难恢复: ark/Velero,Velero/etcd,
sealer[ˈsiːlər]是一款分布式应用打包交付运行的解决方案，通过把分布式应用及其数据库中间件等依赖一起打包以解决复杂应用的交付问题。
kubernetes扩容:virtual-kubelet,cluster-capacity,hpa-operator
kubernetes集群事件采集: kube-eventer(荐),kube-eventrouter,kubernetes-event-exporter
kubernetes成本计算: Kubecost
kubernetes配置导出: neat
KubeVela 是一个简单易用且高度可扩展的应用管理平台与核心引擎。KubeVela 是基于 Kubernetes 与 OAM 技术构建的。
CIS 安全基线:open-scap
Paralus: 零信任安全

Maltrail恶意流量检测系统
网络入侵检测系统: snort,suricata
IDSTower - Suricata IDS Web GUI
SELKS是Stamus Networks公司（位于美国印第安纳州，主要研发Suricata安全产品,OISF执行团队的成员）所开发开源ELK项目，该项目具有带GUI功能的Suricata规则管理系统以及网络威胁搜索功能，SELKS社区版是在GPL v3许可证下发布。
StamusNetwork公司在商业版产品Stamus Security Platform(SSP)中提供了NSM和NDR功能和社区版中提供的IDS共同组成了Stamus安全平台。在SSP（商业版）中支持多传感器部署，系统架构如下图所示。多个传感器将收集的数据发送到管理端集中分析。
Scirius Community Edition is a web interface dedicated to Suricata ruleset management. It handles the rules file and update associated files.
EveBox is a Suricata alert and event management tool for the Suricata IDS/NSM Engine.

[Wazuh](Wazuh · The Open Source Security Platform)是一整套基于ossec安全检测工具和EFK日志工具构成的终端安全管理工具。不管是将其分类至HIDS，还是EDR，它都是一套通过监控主机日志行为，提供安全检测、分析和完整报告的开源、免费利器

上网行为管理: Panabit,Zenarmor

Kyverno 是一个为 Kubernetes 设计的开源策略引擎，作为 Kubernetes 资源进行管理，不需要新的语言来编写策略。策略引擎是什么？它是一个软件，允许用户定义一组可以用来验证、改变（mutate）和生成 Kubernetes 资源的策略。作为 CNCF 的一个沙箱项目，Kyverno 开始得到社区的支持和关注。由于近年来软件供应链攻击的增加，Kyverno 越来越受欢迎。Kyverno 通过支持验证镜像签名[1]和in-toto 证明[2]来保护工作负载。这些工作负载保护是通过cosign[3]和SLSA[4]框架实现的。

NeuVector：业内首个开源容器安全平台
kubernetes边缘计算: KubeEdge+Sedna,StarlingX、K3s、EdgeXfoundry、EdgeGallery、Akraino、Baetyl、OpenYurt、SuperEdge、Azure IoT Edge,superedge

FreeFEM是开源的有限元模拟系统，由法国利翁斯实验室、埃尔和玛丽居里大学共同开发，在世界范围内广泛使用。

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
专注网络安全与渗透测试的操作系统：Parrot 
把各种旧电脑和旧电子设备变成游戏终端：Lakka
Linux 系统救援发行版：SystemRescue
专注多媒体影音工作的发行版：AV Linux
通过隔离提供安全保障的桌面操作系统，Qubes OS 

FuguIta is a live system based on OpenBSD operating system.
OpenBSD CD Bootable Firewall System
Anonym.OS LiveCD
OliveBSD - OpenBSD LiveCD
Quetzal - A Live OpenBSD System
OpenBSD Live-CD Firewall
The jggimi OpenBSD-based LiveCD / LiveDVD
MarBSD - Meine OpenBSD-Live-CD
BSDanywhere - The OpenBSD LiveCD at your fingertips
OpenBSD 4.1 Live CD
flashboot
flashdist / flashrd
LiveUSB OpenBSD - Carry a bootable UNIX on USB pendrive
resflash - Resilient OpenBSD images for flash memory

开发工具: Telepresence,Keel,Apollo,Deis Workflow,Kel,
安全工具: anchore,clair,cert-manager,docker-bench-security,magic-namespace,notary,OpenSCAP,trireme,NeuVector,Deepfence,StackRox,Tenable,Cavirin,Kube-Bench,Sysdig Falco,Sysdig Secure,Kubesec.io;付费 Aquasec,flawcheck,portshift-operator,bane apparmor,
Akvorado是一个功能全面且易于使用的网络流量管理工具，无论你是专业的网络运维人员还是对网络数据感兴趣的初学者，都值得尝试。只需访问其演示站点或自己搭建，就能体验到它带来的强大性能和便捷性。
安全平台: Wazuh,
安全审计: Auditbeat+ELK,
编排转换：kompose
云管理软件(CMP): ManageIQ/CloudForms,腾讯蓝鲸(BlueKing),CODO,VMware vRealize Suite,AbiCloudi/Abiquo,Micro Focus,Scalr,RackSpace,RightCloud,RightScale,SaCa Aclome,新浪DCP,Cloudify,Mist.io,VirtEngine,openQRM,OpenNebula,Eucalyptus,天云SkyForm CMP,ZStack CMP,博云BeyondCMP,Cisco InterCloud,骞云SmartCMP,飞致云FIT2CLOUD,云霁CloudRes,浪潮OpsNow,行云管家,新钛云服TiOps,华讯CloudEagle，神州SmartCOP，九州云Animbus CMP，海云捷迅AWCloud，IBM MCMP,IBM Cloud Management，深信服云管平台,OpenNebula,Cloudability,Cloudyn Cloud Management,Dell Cloud Manager v11,BMC Cloud Management,HP Hybrid Cloud Management,CSC Agility Platform,优维EasyOps,BigOps,openpitrix
云平台:OpenStack、CloudStack、Hadoop、Apache Mesos、基于Docker的kubernetes、swarm，微软System Center，AzureStack,EasyStack,CloudFoundry,CBSD,CacheCloud(redis)

备份/恢复/迁移: mydumper,zkcopy,mongodb_consistent_backup, WAL-E,Bacula/baculum,Backupninja,amanda,Backuppc,UrBackup,restic,veleo
mhVTL虚拟化磁带库
最值得考虑的两大Linux备份工具：Amanda和Bacula
EMC NetWorker (formerly Legato NetWorker) is an enterprise-level data protection software product from Dell EMC that unifies and automates backup to tape, disk-based, and flash-based storage media across physical and virtual environments for granular and disaster recovery.
Arcserve | Data Protection Solutions For Business 
Arkeia Software (/ɑːrˈkiːə/ ar-KEE-ə)[1] is an American computer software company. It produces network backup software for 200 platforms including Windows, Macintosh, Linux, AIX, BSD and HP-UX, and also a backup appliance, integrating its software with disk storage and network connectivity. In January 2013, Western Digital Corporation announced it had acquired Arkeia Software.[2] In May 2015, a community representative for WDC posted on their forum, indicating that the Arkeia Network Backup product line was being phased out.[3]
Perfect Backup 是适用于 Windows 的全功能备份软件。 它对任何目的都是免费的
Duplicati software is supported by Windows, MacOS and Linux, as well as a range of standard protocols, including SS, FTP, cloud services and WebDAV. It is useful if strong encryption is needed by the user. Licensed under the GPL, it gives users the ability to store encrypted, incremental, and compressed backups on cloud storage servers and remote file servers. The software offers features like filters, deletion rules and bandwidth options to run backups.

PaaS:flynn,tsuru,service-catalog

负载均衡: gimbal,metallb,porter,GLB Director,DPDK-LVS/DPVS,Jupiter,Seesaw,LoadMaster by KEMP,HAProxy,Zevenet,PEN,Gobetween,Kube-Vip
Libra: A Stateful Layer-4 Load Balancer with Fair Load Distribution
HDSLB: High-Density Scalable Load Balancer(HDSLB) is a high performance server-based Layer-4 load balancer.
loxilb: loxilb is an open source cloud-native load-balancer based on GoLang/eBPF with the goal of achieving cross-compatibility across a wide range of on-prem, public-cloud or hybrid K8s environments.
SKYLB: 京东 skylb，依靠路由协议来实现IP层ECMP，也就是的第一级负载均衡，设计实现一套高可靠、高性能、易维护及性价比高的L4负载均衡系统。
MGW: 美团 MGW
F5：BIG-IP 商用负载均衡器产品F5 BIG-IP
性能梯队: 普通cpu +lvs< 通用CPU+DPDK加速 < DPU卸载 L4LB < 可编程ASCI交换机芯片

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

https://www.kubeblocks.io/ 
Run Any Database on Kubernetes

Kubestack(elasticsearch,etcd,memcached,postgresql,prometheus)

kafka-operator: Banzai Cloud/koperator,Krallistic,Strimzi(荐),Confluent

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

https://github.com/Stirling-Tools/Stirling-PDF

开源数据集
HuggingFace开源数据集

链接：https://huggingface.co/datasets

镜像：https://hf-mirror.com/datasets

OpenDataLab开源数据集

链接：https://opendatalab.com/
AWS亚马逊开源数据集

链接：https://registry.opendata.aws/
微软开源数据集

链接：https://www.microsoft.com/en-us/research/tools/


谷歌开源数据集

链接：https://datasetsearch.research.google.com/
GitHub开源数据集

链接：https://github.com/awesomedata/awesome-public-datasets


ModelScope开源数据集

链接：https://modelscope.cn/datasets
LUGE千言开源数据集

链接：https://www.luge.ai/
TIANCHI天池开源数据集

链接：https://tianchi.aliyun.com/dataset/


kaggle开源数据集

链接：https://www.kaggle.com/datasets


UCI开源数据集

链接：https://archive.ics.uci.edu/datasets
计算机视觉开源数据集

链接：https://visualdata.io/discovery


Dataju聚数力开源数据集

链接：http://dataju.cn/Dataju/web/home
Hyper超神经开源数据集

链接：https://hyper.ai/datasets

BAAI开源数据集

链接：https://data.baai.ac.cn/data


百度飞桨开源数据集

链接：https://aistudio.baidu.com/datasetoverview
payititi帕衣提提开源数据集

链接：https://www.payititi.com/opendatasets/
启智开源数据集

链接：https://openi.pcl.ac.cn/explore/datasets


和鲸开源数据集

链接：https://www.heywhale.com/home/dataset



