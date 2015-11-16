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
#Make sure your slaves are able to pull packages.  For this environment you need to run the siege/setup_slaves.sh script first.

while read -r f

  do

    ssh -o StrictHostKeyChecking=no cloud-user@$f 'screen -m -d apt-get install -y phoronix-test-suite'
    scp -o StrictHostKeyChecking=no /opt/trunk/mythos/medusa/phoronix/slave-user-config.xml cloud-user@$f:/root/.phoronix-test-suite/user-config.xml

done < /opt/trunk/mythos/medusa/discovery/ip_addresses.dat

Sleep 30

echo "Phoronix slave hosts ready..."
