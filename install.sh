#!/bin/bash
# Starter installer script
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Install Zabbix to CentOS

# Envs
# ---------------------------------------------------\
PATH=$PATH:/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin
SCRIPT_PATH=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)

# POSIX / Reset in case getopts has been used previously in the shell.
OPTIND=1

_agent="/etc/zabbix/zabbix_agentd.conf"
_server="/etc/zabbix/zabbix_server.conf"

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

_exit() { 
    echo "Bye bye!"
    exit 0
}

function setChoise()
{
    echo -e "What do you want install?\n"
    echo "   1) Agent"
    echo "   2) Server"
    echo "   3) Exit"
    echo ""
    read -p "Install [1-3]: " -e -i 3 INSTALL_CHOICE

    case $INSTALL_CHOICE in
        1)
        _installAgent=1
        ;;
        2)
        _installServer=1
        ;;
        3)
        _exit
        ;;
    esac

    if [[ "$_installAgent" == 1 ]]; then
        if confirm "Install Zabbix Agent (y/n)?"; then

            if [ -f $_agent ]; then
                echo "Zabbix Agent already installed!"
                _exit
            else
                read -p 'Zabbix server ip: ' zabbsrvip
                $SCRIPT_PATH/modules/agent.sh $zabbsrvip
            fi

        fi
    fi

    if [[ "$_installServer" == 1 ]]; then
        if confirm "Install Zabbix Server (y/n)?"; then
            
            if [ -f $_server ]; then
                echo "Zabbix Server already installed!"
                _exit
            else
                $SCRIPT_PATH/modules/server.sh
            fi
            
        fi
    fi

}

setChoise
