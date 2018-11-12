### Zabbix 4 installer for CentOS 7
Fully automated bash script for install Zabbix server and agent on the CentOS host.

### Features
* Install Zabbix 4.0
* Install php 7.2
* Configure php.ini
* Configure zabbix config
* Configure SELinux
* Configure Firewalld
* Secure zabbix agent

### Zabbix updater
On source server:
* Stop zabbix service
* Export zabbix database
```
mysqldump -uroot -p<password> --database <Db_name> > <backup_name>.sql 
```
* Compress your arhive and put to new installed server

On new installed server:
* Change archive name and slq backup name in the update-zabbix.sh file
* Run update script

## Links
https://www.zabbix.com/documentation/4.0/manual/installation/install_from_packages/rhel_centos
https://www.zabbix.com/forum/zabbix-help/22576-copying-duplicating-zabbix-configuration
https://www.zabbix.com/forum/zabbix-help/50603-export-configuration-to-a-new-installation
https://zabbix.org/wiki/Docs/howto/upgrade/Upgrade_Zabbix_1.8_to_2.0_and_Migrate_Mysql_to_Postgresql
http://bertvv.github.io/notes-to-self/2015/11/16/automating-mysql_secure_installation/