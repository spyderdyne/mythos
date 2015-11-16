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

# update hosts lists
echo "Preparing host lists"
sleep 2
/opt/trunk/mythos/medusa/discovery/address_parser.sh

# verify slaves (DEBUG ONLY)
#echo "Verifying Slave Connections"
#sleep 2
#/opt/trunk/mythos/medusa/siege/verify_slaves.sh | tee /opt/trunk/mythos/medusa/siege/slave-verification.txt

#prepare the server
#start phoromatic
#init slave discovery

# prepare the slaves
echo "Preparing Slave Instances"
sleep 2
/opt/trunk/mythos/medusa/siege/setup-slaves.sh | tee /opt/trunk/mythos/medusa/slave-configs.txt

# attack
echo "Launching Test Plans. May the gods be with you..."
sleep 2
/opt/trunk/mythos/medusa/snake_charmer.sh | tee /opt/trunk/mythos/medusa/medusa.log
