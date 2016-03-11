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
# Medusa image creation script.  Execute this to generate master and slave
# images for upload to your cloud provider in the proper format.
#
#
#
# author:  James Scollard
# email:  jscollar@cisco.com
# source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos

source ../../set-environment.sh

(
date
whoami
echo log_outage.sh : "$@"
echo --
echo
) >> $mythos_home/seshat/clients/$HOSTNAME/${HOSTNAME}_outages.log 2>&1 &