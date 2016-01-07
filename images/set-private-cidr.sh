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

echo "Please input the network CIDR address of your private, VPC, or overlay network.  This private range will be used for all client instances:  "

read private_cidr

source ../set-environment.sh

# Set the base environment setting if the master IP has changed
if [ $private_cidr = $medusa_private_cidr ]
  then
    echo "Master IP Address Already set!  Moving on..."
  else
    sed -i "s/$medusa_egress_gateway/$egress_gateway/g" "$mythos_home/set-environment.sh"
    echo "The master IP address has been updated to $egress_gateway"
fi

# Set Puppet manifests with the proper IP addresses
#sed -i "s/replace_private_cidr/$private_cidr/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp" #not currently used...

sed -i "s/replace_private_cidr/$private_cidr/g" "medusa_serpent/modules/medusa_serpent/manifests/init.pp"

echo "You have successfully set the Master IP address for your images to $private_cidr.  Proceeding to image creation..."