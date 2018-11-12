#!/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Switch installed agent to PSK work mode

# Envs
# ---------------------------------------------------\
HOST_NAME=$(hostname)

Info() {
  printf "\033[1;32m$@\033[0m\n"
}

# Install
# ---------------------------------------------------\
echo -en "Secure agent? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Generate PSK..."

    TLSType="psk"
    PSKIdentity=${HOST_NAME%.*.*}

    sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"

    sed -i 's/# TLSConnect=.*/TLSConnect=psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i 's/# TLSAccept=.*/TLSAccept=psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i 's/# TLSPSKFile=.*/TLSPSKFile=\/etc\/zabbix\/zabbix_agentd.psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i "s/# TLSPSKIdentity=.*/TLSPSKIdentity="$HOST_NAME"/" /etc/zabbix/zabbix_agentd.conf

    systemctl restart zabbix-agent

    Info "PSK - $(cat /etc/zabbix/zabbix_agentd.psk)"
    Info "PSKIdentity - $PSKIdentity"

else
      echo -e "Ok, you agent is will be insecure..."
fi

exit