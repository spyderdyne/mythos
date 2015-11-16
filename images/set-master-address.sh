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
# Sets the master "floating" IP address that will be assigned to the master server

echo "please input the IP address you want to use for your master node.  This address must be accessible by your slave instances:  " 

read master_float

sed -i "s/replace_ip_address/$master_float/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp"

sed -i "s/replace_ip_address/$master_float/g" "medusa_serpent/modules/medusa_serpent/manifests/init.pp"

echo "You have successfully set the Master IP address for your images to $master_float.  There is nothing left to configure.  Please proceed to image creation."