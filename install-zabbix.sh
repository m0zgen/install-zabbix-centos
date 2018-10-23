#!/bin/bash
# Install zabbix to CentOS
# Created by Yevgeniy Goncharov, https://sys-adm.in

PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

TIMEZONE_REGION="Asia"
TIMEZONE_CITY="Almaty"
SERVER_IP=$(hostname -I | cut -d' ' -f1)
SERVER_NAME=$(hostname)
DB_ZAB_PASS="uphoo6Ae"
DB_ROOT_PASS="paeWoo5u"

yum install epel-release yum-utils net-tools nano -y

rpm -ivh https://repo.zabbix.com/zabbix/4.0/rhel/7/x86_64/zabbix-release-4.0-1.el7.noarch.rpm
yum-config-manager --enable rhel-7-server-optional-rpms


yum install mariadb mariadb-server -y
systemctl start mariadb && systemctl enable mariadb

#

mysql --user=root <<_EOF_
  UPDATE mysql.user SET Password=PASSWORD('${DB_ROOT_PASS}') WHERE User='root';
  DELETE FROM mysql.user WHERE User='';
  DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');
  DROP DATABASE IF EXISTS test;
  DELETE FROM mysql.db WHERE Db='test' OR Db='test\\_%';
  FLUSH PRIVILEGES;
_EOF_

# my.cnf!!!

# echo -e "\ny\ny\npassword\npassword\ny\ny\ny\ny" | /usr/bin/mysql_secure_installation

# mysql_secure_installation <<EOF

# y
# ${DB_ROOT_PASS}
# ${DB_ROOT_PASS}
# y
# y
# y
# y
# EOF

cat <<EOF | mysql -uroot -p$DB_ROOT_PASS
create database zabbix character set utf8 collate utf8_bin;
grant all privileges on zabbix.* to zabbix@localhost identified by '${DB_ZAB_PASS}';
flush privileges;
EOF

rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm
yum-config-manager --enable remi-php72

yum install zabbix-server-mysql zabbix-web-mysql zabbix-agent httpd -y

zcat /usr/share/doc/zabbix-server-mysql-4.0.0/create.sql.gz | mysql -uroot -p$DB_ROOT_PASS zabbix

#
sed -i 's/# DBHost=.*/DBHost=localhost/' /etc/zabbix/zabbix_server.conf
sed -i 's/# DBName=.*/DBName=zabbix/' /etc/zabbix/zabbix_server.conf
sed -i 's/# DBUser=.*/DBUser=zabbix/' /etc/zabbix/zabbix_server.conf
sed -i "s/# DBPassword=.*/DBPassword="$DB_ZAB_PASS"/" /etc/zabbix/zabbix_server.conf


#
sed -i 's/^\(max_execution_time\).*/\1 = 300/' /etc/php.ini
sed -i 's/^\(memory_limit\).*/\1 = 128M/' /etc/php.ini
sed -i 's/^\(post_max_size\).*/\1 = 16M/' /etc/php.ini
sed -i 's/^\(upload_max_filesize\).*/\1 = 2M/' /etc/php.ini
sed -i 's/^\(max_input_time\).*/\1 = 300/' /etc/php.ini
sed -i "s/^\;date.timezone.*/date.timezone = \'"$TIMEZONE_REGION"\/"$TIMEZONE_CITY"\'/" /etc/php.ini


systemctl enable zabbix-server && systemctl start zabbix-server

firewall-cmd --permanent --add-service=http
firewall-cmd --reload

systemctl enable httpd && systemctl start httpd
