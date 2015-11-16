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

function clean_environments() {
  rm -rf ~/.mythosrc
}

function set_mythos_home() {
export MYTHOS_HOME="$PWD"
echo "Setting Mythos Home to $MYTHOS_HOME"
echo "MYTHOS_HOME=$MYTHOS_HOME" > ~/.mythosrc
}

function add_source_variables() {
  while true; do
      read -p "Would you like to source an environment file?" yn
      case $yn in
          [Yy]* ) read -p "what file would you like to source?" rc_file
                  cat $rc_file >> ~/.mythosrc
                  exit 0;;
          [Nn]* ) echo "You can return any time to add an RC file if you need to. You have completed Mythos initial setup."
                  exit 0;;
          * ) echo "Please answer Y/n.";;
      esac
  done
}

function set_private_subnets() {

  read -p "Please enter a subnet using slashDot notation: " private_network
    if [ $private_network = "([0-9]{1,3}[\.]){3}[0-9]{1,3}[1-3]{1}'/'[0-9]{1}" ]
    then
      echo "private address $private_network received."
    else
      echo "not a valid range."
      exit 1
  fi

}