#!/bin/bash

PATH="/sbin:/usr/sbin:/bin:/usr/bin"
export PATH

DBHost=mysql-db
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
DBPort=3306

BAK_DIR="/zabbix_backup/"
BAK_LOG_FILE="/var/log/zabbix_bk_log"
DEL_FILE_DAYS=7
DATE_NOW=$(date +'%Y-%m-%d')
FILTER_TABLE="history_uint|history|trends_uint|trends|history_text|alerts|events|history_str|history_log|history_text"
[ -d $BAK_DIR ] || mkdir -p $BAK_DIR

for tablename in $(mysql -h"$DBHost" -u"$DBUser" -p"$DBPassword" -P"$DBPort" $DBName -e "show tables;" 2>/dev/null | grep -Ev "$FILTER_TABLE");do
    echo dump table: ${tablename}
    /usr/bin/mysqldump -N -h"$HOSTSER" -u"$DBUser" -p"$DBPassword" -P"$DBPort" --set-gtid-purged=OFF $DBName ${tablename} >>${BAK_DIR}/zabbixdb.${DATE_NOW}.sql 2>>${BAK_LOG_FILE}
done

cd /zabbix_backup/zabbix_scripts_backup

tar czvf zabbix.tgz.$(date +%F) /zabbix

find $BAK_DIR -type f -ctime +${DEL_FILE_DAYS} | xargs rm -f
find /zabbix_backup/zabbix_scripts_backup -type f -ctime +${DEL_FILE_DAYS} | xargs rm -f
