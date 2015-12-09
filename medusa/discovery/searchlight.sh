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
# This script currently requires Virtualbox to run
#
# author:  James Scollard
# email:  jscollar@cisco.com
# source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos

#if grep -q MYTHOS_HOME "~/.mythsrc"; then
#    source ~/.mythosrc
#  else
#    . ../../set-environment.sh
#    clean_environments
#    set_mythos_home
#    source ~/.mythosrc
#fi

source ../../set_environment.sh

#discover hosts on local networks
nmap -p 80 192.168.0.0/24 --exclude 192.168.0.1 > $medusa_home/discovery/discovered_hosts.txt

#Clean host lists to only include addresses/DNS names
$medusa_home/discovery/address_parser.sh