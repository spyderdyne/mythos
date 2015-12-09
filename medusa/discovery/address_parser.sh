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
#source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythosexport

#if grep -q MYTHOS_HOME "~/.mythsrc"; then
#    source ~/.mythosrc
#  else
#    . ../../set-environment.sh
#   clean_environments
#   set_mythos_home
#    source ~/.mythosrc
#fi

source ../../set_environment.sh

#find IP addresses in nasty results files and save them
grep -E -o "([0-9]{1,3}[\.]){3}[0-9]{1,3}" $medusa_home/discovery/discovered_hosts.txt > $mythos_home/discovery/messy.dat

#groom the results and output to a clean file with only one of each address
sort $medusa_home/discovery/messy.dat | uniq -u > $medusa_home/discovery/ip_addresses.dat
