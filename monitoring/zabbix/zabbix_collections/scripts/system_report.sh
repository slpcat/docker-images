#!/bin/bash

DB_HOST='mysql-db'
DB_USER='zabbix'
DB_PASSWD='zabbix'
DB_PORT='3306'
DB_CMD="mysql --batch -h $DB_HOST -u$DB_USER -p$DB_PASSWD -P$DB_PORT -e "
EMAIL='mail@example.com'

DATE_TIME=$(date -d "-15 min" +%s)

DISK_FILE="/tmp/disk_$(date +%F).csv"
CPU_FILE="/tmp/cpu_$(date +%F).csv"
REPORT_FILE="/tmp/$(date +%F)_性能数据汇总报表.csv"

$DB_CMD "use zabbix;select g.name as Group_Name,',',h.host as Host,',',round(hi.value,2) as "磁盘空间"
from hosts_groups hg join groups g on g.groupid = hg.groupid
join items i on hg.hostid = i.hostid
join hosts h on h.hostid=i.hostid
join history hi on i.itemid = hi.itemid where i.key_='vfs.fs.size[/,pused]'
and hi.clock > ${DATE_TIME}
group by h.host ;" >${DISK_FILE} 2>/dev/null

DATE_TIME_AGO=$(date -d "-7 day" +%s)

$DB_CMD "use zabbix;
select g.name as Group_Name,',',h.host as Host,',',round(avg(hi.value_min),2) as "Cpu_Idel"
from hosts_groups hg join groups g on g.groupid = hg.groupid
join items i on hg.hostid = i.hostid
join hosts h on h.hostid=i.hostid
join trends hi on i.itemid = hi.itemid where i.key_='system.cpu.util[,idle]'
and hi.clock >= ${DATE_TIME_AGO} and hi.clock < ${DATE_TIME}
group by h.host ;" >${CPU_FILE} 2>/dev/null

awk -F"," 'NR==FNR{a[$1,$2]=$NF;next}{print $0,",",a[$1,$2]}' $DISK_FILE $CPU_FILE | awk '{print $1.$2,$3,$4,$5,$6,$7,$8,$9,$10}' > $REPORT_FILE

echo "$(date)" | mail -s "$(date +%F) 性能报表" -a $REPORT_FILE $EMAIL
