#!/bin/bash
#时间戳，用来区分不同备份
timestamp=`date +%Y%m%d-%H%M%S`
#备份到哪个文件夹
back_dir="/app/backup/etcd"
#etcd集群列表
endpoints="http://172.16.1.1:2379,http://172.16.1.2:2379,http://172.16.1.3:2379,http://172.16.1.4:2379,http://172.16.1.5:2379"
#etcd证书路径
cert_file="/etc/etcd/ssl/etcd.pem"
#etcd证书的key路径
key_file="/etc/etcd/ssl/etcd-key.pem"
#ca证书路径
cacert_file="/etc/kubernetes/ssl/ca.pem"

mkdir -p $back_dir
#ETCDCTL_API=3 /app/etcd/etcdctl \
#--endpoints="${endpoints}" \
#--cert=$cert_file \
#--key=$key_file \
#--cacert=$cacert_file \
#snapshot save $back_dir/snapshot_$timestamp.db

ETCDCTL_API=3 /app/etcd/etcdctl \
  --endpoints="${endpoints}" \
  snapshot save $back_dir/snapshot_$timestamp.db

