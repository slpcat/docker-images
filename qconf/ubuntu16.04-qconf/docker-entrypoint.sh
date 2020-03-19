#!/bin/bash
set -eu
sed -i s/^daemon_mode=.*$/daemon_mode=0/ conf/agent.conf
sed -i 's/^#log_fmt=.*$/log_fmt=\/qconf\/logs\/qconf.log.%Y-%m-%d-%H/' conf/agent.conf
#set IDC
echo $LOCAL_IDC > conf/localidc
#set ZOOKEEPER
sed -i s/^zookeeper.test.*$/zookeeper.${LOCAL_IDC}=${ZK_LIST}/ conf/idc.conf
#start agent
bash bin/agent-cmd.sh start
