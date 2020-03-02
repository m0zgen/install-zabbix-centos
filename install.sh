#!/bin/bash
# Starter installer script
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Install Zabbix to CentOS

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

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

function isServer()
{
	if [[ -f /etc/zabbix/zabbix_server.conf ]]; then
		_isServer=1
	fi
}

function isAgent()
{
	if [[ -f /etc/zabbix/zabbix_agentd.conf ]]; then
		_isAgent=1
	fi
}

function setChoise()
{
	echo -e "What do you want install?\n"
	echo "   1) Agent"
    echo "   2) Server"
    echo "   3) Exit"
    read -p "Install [1-3]: " -e -i 3 INSTALL_CHOICE

    case $INSTALL_CHOICE in
        1)
        _installAgent=1
        ;;
        2)
        _installServer=1
        ;;
        3)
        echo "Bye bye!"
        exit 0
        ;;
    esac

    if [[ "$_installAgent" == 1 ]]; then
    	if confirm "Install Zabbix Agent?"; then
    		if [[ "$_isAgent" == "" ]]; then

                read -p 'Zabbix server ip: ' zabbsrvip

				$SCRIPT_PATH/modules/agent.sh $zabbsrvip
			else
				echo "Zabbix Agent already installed!"
				exit 1
			fi
    	fi
    fi

    if [[ "$_installServer" == 1 ]]; then
    	if confirm "Install Zabbix Server?"; then
    		if [[ "$_isServer" == "" ]]; then
				$SCRIPT_PATH/modules/server.sh
			else
				echo "Zabbix Server already installed!"
				exit 1
			fi
    		
    	fi
    fi

}

setChoise

