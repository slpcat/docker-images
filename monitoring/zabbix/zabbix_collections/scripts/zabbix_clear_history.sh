DBHost=mysql-db
DBName=zabbix
DBUser=zabbix
DBPassword=zabbix
Date=`date -d $(date -d "-120 day" +%Y%m%d) +%s`
mysql -h${DBHost} -u${DBUser} -p${DBPassword} 2> /dev/null -e "
use ${DBName};
DELETE FROM history WHERE 'clock' < $Date;
#optimize local table history;
#ALTER TABLE history ENGINE='InnoDB';
DELETE FROM history_uint WHERE 'clock' < $Date;
#optimize local table history_uint;
#ALTER TABLE history_uint ENGINE='InnoDB';
DELETE FROM history_text WHERE 'clock' < $Date;
#optimeze local table history_text;"
#ALTER TABLE history_text ENGINE='InnoDB';
