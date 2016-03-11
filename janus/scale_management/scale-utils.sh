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
# provides cleanup mechanisms for scale testing

OPERATION=${1}

snapshot() {

        echo "Collecting bulk configuration information"
        keystone tenant-list | grep Scale > tenant-list.txt
        keystone user-list | grep Scale > user-list.txt
        neutron router-list | grep Scale > router-list.txt
        neutron net-list | grep Scale > net-list.txt
        neutron subnet-list | grep Scale > subnet-list.txt
        nova list --all-tenants | grep Scale > instance-list.txt
}

drop-network() {

        for ROUTERID in `grep ${PATTERN} router-list.txt | awk '{print $4}'`
        do
                echo "Working on ${ROUTERID}"
                TENANT=`echo ${ROUTERID} | awk -F- '{print $3}'`
                ROUTERID=`grep ${ROUTERID} router-list.txt | awk '{print $2}'`
                NETID=`grep Scale-Network-${TENANT} net-list.txt | awk '{print $2}'`
                SUBNETID=`grep Scale-Subnet-${TENANT} subnet-list.txt | awk '{print $2}'`

                if [ ${TEST} -eq 1 ]
                then
                        echo "neutron router-gateway-clear ${ROUTERID}"
                        echo "neutron router-interface-delete ${ROUTERID} subnet=${SUBNETID}"
                        echo "neutron router-delete ${ROUTERID}"
                        echo "neutron subnet-delete ${SUBNETID}"
                        echo "neutron net-delete ${NETID}"
                else
                        neutron router-gateway-clear ${ROUTERID}
                        neutron router-interface-delete ${ROUTERID} subnet=${SUBNETID}
                        neutron router-delete ${ROUTERID}
                        neutron subnet-delete ${SUBNETID}
                        sleep 1
                        neutron net-delete ${NETID}
                fi
        done
}

drop-tenant() {

        for TENANTID in `grep ${PATTERN} tenant-list.txt | awk '{print $2}'`
        do
                if [ ${TEST} -eq 1 ]
                then
                        echo "keystone tenant-delete ${TENANTID}"
                else
                        echo "Deleting ${TENANTID}"
                        keystone tenant-delete ${TENANTID}
                fi
        done
}

drop-instance() {

        IDLIST=""
        COUNT=0

        for INSTANCE in `grep ${PATTERN} instance-list.txt | awk '{print $2}'`
        do
                if [ ${COUNT} -eq 5 ]
                then
                        if [ ${TEST} -eq 1 ]
                        then
                                echo "nova delete ${IDLIST}"
                        else
                                echo "Deleting ${IDLIST}"
                                nova delete ${IDLIST}
                        fi
                        IDLIST="${INSTANCE}"
                        COUNT=1
                else
                        IDLIST="${IDLIST} ${INSTANCE}"
                        COUNT=$((COUNT+1))
                fi
        done

        if [ ${TEST} -eq 1 ]
        then
                echo "nova delete ${IDLIST}"
        else
                nova delete ${IDLIST}
        fi
}

case "${OPERATION}" in

        snapshot)
                snapshot
        ;;

        drop-network|drop-tenant|drop-instance)

                if [[ -z ${2} ]]
                then
                        echo "Usage: ${0} ${OPERATION} <Instance-Pattern>"
                        exit
                else
                        PATTERN=${2}
                fi

                if [[ -z ${3} ]]
                then
                        TEST=0
                else
                        TEST=1
                fi

                ${OPERATION}
        ;;

        *)
                echo "Usage: ${0} snapshot"
                echo "Usage: ${0} <drop-network|drop-tenant|drop-instance> <Pattern>"
                echo "Usage: ${0} <drop-network|drop-tenant|drop-instance> <Pattern> TEST"
        ;;
esac