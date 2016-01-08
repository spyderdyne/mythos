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
# Displays the current master "floating" IP address that will be assigned to the master server.

source ../set_environment.sh

gorgon_master_address=$(cat $mythos_home/images/medusa_gorgon/modules/medusa_gorgon/manifests/init.pp | grep master_ip)
serpent_master_address=$(cat $mythos_home/images/medusa_serpent/modules/medusa_serpent/manifests/init.pp | grep master_ip)

#display master address
echo "Gorgon public address as set in Gorgon module config: $gorgon_master_address"

#display serpent address
echo "Gorgon public address as set in Serpent module config: $serpent_master_address"


