### Zabbix 4 installer for CentOS 7
Fully automated bash script for install Zabbix server and agent on the CentOS host.

### Features
* Install Zabbix 4.0
* Install php 7.2
* Configure php.ini
* Configure zabbix config
* Configure SELinux
* Configure Firewalld

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


