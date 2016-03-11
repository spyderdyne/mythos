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
#
# Uses inotify to monitor the outage log for appends, and notifies the server node if
# an outage occurs.

source ../../set-environment.sh

while inotifywait -q -e modify $mythos_home/seshat/clients/$HOSTNAME/${HOSTNAME}_outages.log >/dev/null; do
    /bin/sleep $[ ( $RANDOM % 600 )  + 1 ]s # sleep random time up to 10 minutes to prevent server crashes and lockups
    rsync $mythos_home/seshat/clients/$HOSTNAME/${HOSTNAME}_outages.log medusa_gorgon:$mythos_home/seshat/clients/$HOSTNAME/${HOSTNAME}_outages.log
done