#!/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Install Zabbix to CentOS
# Thx for template - https://serveradmin.ru/monitoring-ssh-loginov-v-zabbix/

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

_agent="/etc/zabbix/zabbix_agentd.conf"

confirm() {
    # call with a prompt string or use a default
    read -r -p "${1:-Are you sure? [y/N]} " response
    case "$response" in
        [yY][eE][sS]|[yY]) 
            true
            ;;
        *)
            false
            ;;
    esac
}

_conf() {
    chgrp zabbix /var/log/secure
    chmod 640 /var/log/secure
}


if confirm "Activate SSH alert for Auth Login to SSH (y/n)?"; then

    if [ -f $_agent ]; then
        echo "Zabbix config found..."
        _conf
        echo "Done. Please import template to Zabbix server:"
        echo "$SCRIPT_PATH/ssh-auth-monitor.xml"
    else
        echo "Zabbix agent does not installed!"
        exit 1
    fi

fi
