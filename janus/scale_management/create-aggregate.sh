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
# creates hypervisor aggregates


AGGNAME="Some-Aggregate-Name"
ZONE="enter-region-here"

nova aggregate-create ${AGGNAME} ${ZONE}

nova aggregate-set-metadata ${AGGNAME} Scale-Micro-Small=true ram_allocation_ratio=2.0 cpu_allocation_ratio=2.0

for HOST in `nova service-list | grep compute | grep ${ZONE} | grep enabled | grep -v " nova " | awk '{print $4}'`
do
        nova aggregate-add-host ${AGGNAME} ${HOST}
done
