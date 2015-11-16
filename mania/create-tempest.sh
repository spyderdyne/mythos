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
# images for upload to Openstack.
#
# This script currently requires Virtualbox to run
#
# author:  James Scollard
# email:  jscollar@cisco.com
# source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos

#Install Tempest and configure it

TEMPEST_SOURCE='https://github.com/openstack/tempest.git' #Change the source to your local repo if you maintain one.
TEMPEST_DIR='tempest' #If you have your own tempest repo, place the name of it here.

if [ $(dpkg-query -W -f='${Status}' cpu-checker 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
    echo "Tempest is installed already.  Moving on..."
  else
    echo "Installing Tempest Required Dependencies..."
    apt-get install -y build-essential libxml2-dev libxslt-dev libyaml-dev libffi-dev python-virtualenv python-pip python-dev libz-dev libssl-dev git
fi

git clone $TEMPEST_SOURCE

(cd $TEMPEST_DIR/ && pip install tempest)

