#!/bin/bash -x

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
#author:  James Scollard
#email:  jscollar@cisco.com
#source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos
#
# Uses inotify to monitor the outage log for appends, and notifies the server node if
# an outage occurs.

echo "Setting global path variables"

mythos_home=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
echo "Home (Mythos) = $mythos_home"

reporting_home="$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/seshat/clients"
echo "Reporting Home (Seshat) = $reporting_home"

medusa_home="$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/medusa"
echo "Scale Testing Home (Medusa) = $medusa_home"

sanity_home="$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/janus"
echo "Sanity Testing Home (Janus) = $sanity_home"

odin_home="$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)/odin"
echo "Rally Testing Home (Odin) = $odin_home"