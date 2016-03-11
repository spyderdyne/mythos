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
# modifies neutron configured vlan ranges for testing

OLDRANGE="1100:2600"
NEWRANGE="1100:3399"

source /PATH/TO/RC/FILE

ansible -m shell -a "sed -i.bak s/${OLDRANGE}/${NEWRANGE}/g /etc/neutron/plugins/ml2/ml2_conf.ini" net*     # network api server name REGEX
ansible -m shell -a "sed -i.bak s/${OLDRANGE}/${NEWRANGE}/g /etc/neutron/plugins/ml2/ml2_conf.ini" neutron* # neutron router server name REGEX
ansible -m shell -a "sed -i.bak s/${OLDRANGE}/${NEWRANGE}/g /etc/neutron/plugins/ml2/ml2_conf.ini" nova*    # compute server name REGEX

ansible -m shell -a "systemctl restart neutron-openvswitch-agent.service" net*                              # network api server name REGEX
ansible -m shell -a "systemctl restart neutron-server.service" neutron*                                     # neutron router server name REGEX
ansible -m shell -a "systemctl restart neutron-openvswitch-agent.service" nova*                             # compute server name REGEX