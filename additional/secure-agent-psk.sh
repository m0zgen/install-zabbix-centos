#!/bin/bash
# Created by Yevgeniy Goncharov, https://sys-adm.in
# Switch installed agent to PSK work mode

# Envs
# ---------------------------------------------------\
HOST_NAME=$(hostname)
PSKIdentity=${HOST_NAME%.*.*}
TLSType="psk"
RAND_PREFIX="-$TLSType-prefix-$(cat /dev/urandom | tr -dc 'a-zA-Z0-9' | fold -w 4 | head -n 1)"

Info() {
  printf "\033[1;32m$@\033[0m\n"
}

# Install
# ---------------------------------------------------\
echo -en "Secure agent? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Generate PSK..."

    sh -c "openssl rand -hex 32 > /etc/zabbix/zabbix_agentd.psk"

    sed -i 's/# TLSConnect=.*/TLSConnect=psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i 's/# TLSAccept=.*/TLSAccept=psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i 's/# TLSPSKFile=.*/TLSPSKFile=\/etc\/zabbix\/zabbix_agentd.psk/' /etc/zabbix/zabbix_agentd.conf
    sed -i "s/# TLSPSKIdentity=.*/TLSPSKIdentity="$PSKIdentity$RAND_PREFIX"/" /etc/zabbix/zabbix_agentd.conf

    systemctl restart zabbix-agent

    Info "PSK - $(cat /etc/zabbix/zabbix_agentd.psk)"
    Info "PSKIdentity - $PSKIdentity$RAND_PREFIX"

else
      echo -e "Ok, you agent is will be insecure..."
fi

echo -en "Enable active agent feature? (y/n)? "
read answer
if echo "$answer" | grep -iq "^y" ;then
    echo "Enable active agent..."

    sed -i 's/# EnableRemoteCommands=.*/EnableRemoteCommands=1/' /etc/zabbix/zabbix_agentd.conf

else
      echo -e "Ok."
fi

Info "Done!"

exit