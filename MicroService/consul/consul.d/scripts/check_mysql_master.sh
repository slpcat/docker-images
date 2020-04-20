#!/bin/bash
port=$1
user="root"
passwod="123"

comm="/usr/local/mysql/bin/mysql -u$user -h 127.0.0.1 -P $port -p$passwod"
value=`$comm -Nse "select 1"`
primary_member=`$comm -Nse "select variable_value from performance_schema.global_status WHERE VARIABLE_NAME= 'group_replication_primary_member'"`
server_uuid=`$comm -Nse "select variable_value from performance_schema.global_variables where VARIABLE_NAME='server_uuid';"`


# 判断mysql是否存活
if [ -z $value ]
then
   echo "mysql $port is down....."
   exit 2
fi


# 判断节点状态
node_state=`$comm -Nse "select MEMBER_STATE from performance_schema.replication_group_members where MEMBER_ID='$server_uuid'"`
if [ $node_state != "ONLINE" ]
then
   echo "MySQL $port state is not online...."
   exit 2
fi


# 判断是不是主节点
if [[ $server_uuid == $primary_member ]]
then
   echo "MySQL $port  Instance is master ........"
   exit 0
else
   echo "MySQL $port  Instance is slave ........"
   exit 2
fi
