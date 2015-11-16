#! /bin/bash

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

#KloudBuster Cleanup for Rally

echo "Initiating cleanup of Rally outliers.  This can take a long time."
echo
sleep 1

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

# A tool that can represent KloudBuster json results in
# a nicer form using HTML5, bootstrap.js and the Google Charts Javascript library

###############################################################################
#                                                                             #
# This is a helper script which will delete all resources created by          #
# KloudBuster.                                                                #
#                                                                             #
# Normally, KloudBuster will clean up automatically when it is done. However, #
# sometimes errors or timeouts happen during the rescource creation stage,    #
# which will cause KloudBuster out of sync with the real environment. If that #
# happens, a force cleanup may be needed.                                     #
#                                                                             #
# This script will simply grep the resource name with "rally" and delete them.   #
# If running on a production network, please double and triple check all      #
# resources names are *NOT( containing "rally", otherwise they will be deleted   #
# when running with this script.                                              #
#                                                                             #
###############################################################################

# WARNING! WARNING! WARNING!
# IMPORTANT FOR RUNNING KLOUDBUSTER ON PRODUCTION CLOUDS
# ======================================================
#
# DOUBLE CHECK THE NAMES OF ALL RESOURCES THAT DOES NOT BELONG TO KLOUDBUSTER 
# ARE *NOT* CONTAINING "rally"

for line in `nova list --all-tenants | grep rally  | cut -d'|' -f2`; do
    nova delete $line
done

echo -e "`neutron floatingip-list | grep -E '[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+'`" | while read line; do
    fid=`echo $line | cut -d'|' -f2 | xargs`
    portid=`echo $line | cut -d'|' -f5 | xargs`
    if [ "$fid" != "" ] && [ "$portid" = "" ]; then
        neutron floatingip-delete $fid &
    fi
done;

for line in `neutron security-group-list | grep rally | cut -d'|' -f2`; do
    neutron security-group-delete $line &
done;

for line in `nova flavor-list | grep rally | cut -d'|' -f3`; do
    nova flavor-delete $line &
done;

for line in `neutron router-list | grep rally | cut -d'|' -f2`; do
    neutron router-gateway-clear $line
    for line2 in `neutron router-port-list $line | grep subnet | cut -d'"' -f4`; do
        neutron router-interface-delete $line $line2
    done
    neutron router-delete $line
done

for line in `neutron net-list | grep rally | cut -d'|' -f2`; do
    neutron net-delete $line
done

for line in `keystone tenant-list | grep rally | cut -d'|' -f2`; do
    keystone tenant-delete $line
done

for line in `keystone user-list | grep rally | cut -d'|' -f2`; do
    keystone user-delete $line
done

#Openstack Service restarts
echo "Restarting Openstack Services"
#Insert your restart mechanism here.  Mine wont work at your house...
sleep 1
echo 
echo "Service restarts completed."
