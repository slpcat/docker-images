1.单机模式,持久存储
rocketmq-all-in-one.yml
2.集群模式,多master多slave,持久存储，支持在线扩容
主机名命名规范: <集群名>-<类型>-<角色> 相对应的服务名称：<集群名>-nameserver
集群名：集群名称，默认rocketmqcluster,不能包含横杠
类型：服务类型 nameserver broker
角色：broker角色 master slave
3.docker 运行
docker run -d --restart always--net=host slpcat/rocketmq ./mqnamesrv
docker run --net=host slpcat/rocketmq -v -v /data/rocketmq/broker.conf:/opt/rocketmq/conf/broker.conf ./mqbroker -c ../conf/broker.conf -n $ROCKETMQ_NAMESERVER 2>&1
