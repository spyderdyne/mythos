#!/bin/bash

if grep -q MYTHOS_HOME "~/.mythsrc"
  then
    source ~/.mythosrc
  else
    . ../../../set-environment.sh
    clean_environments
    set_mythos_home
    source ~/.mythosrc
fi

SIEGE_HOME="$MYTHOS_HOME/medusa/siege"

echo "Preparing host lists"
source ./configure-siege.sh

 echo "Laying Siege..."
    sleep 2
    pssh -h /opt/trunk/mythos/medusa/discovery/ip_addresses.dat -O UserKnownHostsFile=/dev/null -O StrictHostKeyChecking=no -l cloud-user -t 20 -x '-t -t' 'sudo screen -d -m siege -c10 -t15M -d5 -i -f /opt/trunk/mythos/medusa/siege/medusa-slaves.dat -l /tmp/siege-$HOSTNAME.log &'
