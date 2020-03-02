#!/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Install Zabbix to CentOS

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
	cp $SCRIPT_PATH/active_sessions.conf /etc/zabbix/zabbix_agentd.d/
}


if confirm "Activate SSH alert for active SSH sessions (y/n)?"; then

    if [ -f $_agent ]; then
        echo "Zabbix config found..."
        _conf
        echo "Done. Please import template to Zabbix server:"
        echo "$SCRIPT_PATH/ssh-active-sessions.xml"
    else
        echo "Zabbix agent does not installed!"
        exit 1
    fi

fi
