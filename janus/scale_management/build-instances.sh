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
# source: https://github.com/spyderdyne/mythos/blob/master/janus/scale_management/build-instances.sh
#
# creates instances for scale testing


# Default network layout

ENVRC="/PATH/TO/RC/FILE"                            # path to your RC fileSUBNETADDR="192.168.50.0/24"
IMAGENAME="DESIRED_UUID_GOES_HERE"                  # the UUID of the image you want to use
FLAVOR="DESIRED_UUID_GOES_HERE"                     # the UUID of the flavor you want to use
OS_PASSWORD="DESIRED_UUID_GOES_HERE"                # the admin/user account password to spawn with
EXTNETID="DESIRED_UUID_GOES_HERE"                   # the UUID of the public facing network
PUBKEY="/PATH/TO/KEY/FILE"                          # path to the SSH key file you want to access instance with after spawning
SSHUSER="admin"                                     # the keystone user to spawn with

for TENANT in {00401..00500}                        # tenant/project ID range to spawn
do
        source ${ENVRC}
        ROUTERNAME="Scale-Router-${TENANT}"
        TENANTNAME="Scale-Tenant-${TENANT}"
        NETNAME="Scale-Network-${TENANT}"
        SUBNAME="Scale-Subnet-${TENANT}"
        SCALEHOST="Scale-Instance-${TENANT}"
        PUBKEYNAME="Scale-Key-${TENANT}"

        export OS_TENANT_NAME=${TENANTNAME}

#        echo "Finding Network ${NETNAME}"
        NETWORKID=`grep ${NETNAME} net-list.txt | awk '{print $2}'`

        for HOSTID in {0001..0005}                  # number of instances to spawn per project
        do
                SCALEHOST="Scale-Instance-${TENANT}-${HOSTID}"

                grep ${SCALEHOST} instance-list.txt > /dev/null
                if [ $? != 0 ]
                then
                        echo "creating ${SCALEHOST}"
                        nova boot --image ${IMAGENAME} --nic net-id=${NETWORKID} \
                                --flavor ${FLAVOR} --key-name ${PUBKEYNAME} ${SCALEHOST}
                fi
        done
done