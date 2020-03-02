#/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Backup zabbix DB (create duump)

db="zabbix"
user=$(cat /etc/zabbix/zabbix_server.conf | grep DBUser= | sed 's/^.*=//' | uniq)
pass=$(cat /etc/zabbix/zabbix_server.conf | grep DBPassword= | sed 's/^.*=//')

dest="/root/zabbix_db_dump"

mysqldump --user="$user" --password="$pass" $db > $dest