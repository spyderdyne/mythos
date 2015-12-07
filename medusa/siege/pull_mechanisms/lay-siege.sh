#!/bin/bash -x

HOSTNAME=$(/bin/hostname)

#Capture time
TIME=$(/bin/date)

#lay siege...
siege -c10 -t15M -d5 -i -f /opt/trunk/mythos/medusa/discovery/ip_addresses.dat >> /opt/trunk/mythos/seshat/$HOSTNAME/$TIME.out

#report results
scp /opt/trunk/mythos/seshat/$HOSTNAME/$TIME.out gorgon:/opt/trunk/mythos/seshat/$HOSTNAME/$TIME.out