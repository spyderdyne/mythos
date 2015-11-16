#!/bin/bash

# Copyright 2015 Cisco Systems, Inc.  All rights reserved.
#
#    Licensed under the Apache License, Version 2.0 (the "License"); you may
#    not use this file except in compliance with the License. You may obtain
#    a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
#    Unless required by applicable law or agreed to in writing, software
#    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
#    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
#    License for the specific language governing permissions and limitations
#    under the License.
#
#author:  James Scollard
#email:  jscollar@cisco.com
#source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos

COUNT=0

for IP in `cat /opt/trunk/mythos/medusa/siege/ip_addresses.dat`
do
        timeout 200s ssh -n -t -o UserKnownHostsFile=/dev/null -o StrictHostKeyChecking=no cloud-user@${IP} "/bin/netstat -rn" &
        
        COUNT=`expr $COUNT + 1`

        if [ $COUNT -eq 500 ]
        then
                sleep 30
        fi
done
