#!/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Update zabbix to new release.

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# Vars
# ---------------------------------------------------\
DB_ZAB_PASS=$(cat $SCRIPT_PATH/zabbix-creds.txt | grep DBPass | awk '{print $2}')
DB_ROOT_PASS=$(cat $SCRIPT_PATH/zabbix-creds.txt | grep ROOTPass | awk '{print $2}')
BACKUP_ARCHIVE="zabbix22-backup.tar.gz"

#
cd $SCRIPT_PATH
systemctl stop zabbix-server
tar -xvf $SCRIPT_PATH/$BACKUP_ARCHIVE


# Create zabbix databse and user
cat <<EOF | mysql -uroot -p$DB_ROOT_PASS
drop database zabbix;
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '${DB_ZAB_PASS}';
flush privileges;
EOF

mysql -uroot -p$DB_ROOT_PASS zabbix < $SCRIPT_PATH/zabbix-full22.sql


systemctl start zabbix-server

tail -f /var/log/zabbix/zabbix_server.log
