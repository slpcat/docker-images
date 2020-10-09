#!/bin/bash
set -e
exec >> /var/log/backup_etcd.log

Date=`date +%Y-%m-%d-%H-%M`
EtcdEndpoints="localhost:2379"
EtcdCmd="/usr/local/bin/etcdctl"
BackupDir="/home/backup/etcd"
BackupFile="snapshot.db.$Date"

echo "`date` backup etcd..."

export ETCDCTL_API=3
$EtcdCmd --endpoints $EtcdEndpoints snapshot save  $BackupDir/$BackupFile

echo  "`date` backup done!"
