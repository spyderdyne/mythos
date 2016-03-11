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
# Displays the current egress gateway address that your hosts will pass through to reach the internet.

source ../set_environment.sh

serpent_egress_gateway=$(cat $mythos_home/images/medusa_serpent/modules/medusa_serpent/manifests/init.pp | grep egress_gateway)

#display serpent address
echo "NMap private address as set in Serpent module config: $serpent_private_cidr"


