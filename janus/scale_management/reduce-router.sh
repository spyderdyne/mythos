#!/bin/bash

# Copyright 2016 Cisco Systems, Inc.  All rights reserved.
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
# author:  David Oyler
# email:  doyler@cisco.com
# source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos
# source: https://github.com/spyderdyne/mythos/blob/master/janus/scale_management/
#
# rolls back router creation steps

# Default network layout

SUBNETADDR="192.168.100.0/24"

for INSTANCE in {00001..00003}
do

        TENANTNAME="Scale-Tenant-${INSTANCE}"
        export OS_TENANT_NAME=${TENANTNAME}

        ROUTERNAME="Scale-Router-${INSTANCE}"
        NETNAME="Scale-Network-${INSTANCE}-0002"
        SUBNAME="Scale-Subnet-${INSTANCE}-0002"

        ROUTERID=`grep ${ROUTERNAME} router-list.txt | awk '{print $2}'`
        NETWORKID=`grep ${NETNAME} net-list.txt | awk '{print $2}'`
        SUBNETID=`grep ${SUBNAME} subnet-list.txt | awk '{print $2}'`

        echo "Adding interface to router"
        neutron router-interface-delete ${ROUTERID} subnet=${SUBNETID}
        sleep 1

        echo "Creating subnet ${SUBNAME}"
        neutron subnet-delete ${SUBNETID}

        echo "Creating network ${NETNAME}"
        neutron net-delete ${NETWORKID}

done