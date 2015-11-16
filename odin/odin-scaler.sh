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

START=7
END=7


#Check if Rally is available
command -v rally >/dev/null 2>&1 || { echo >&2 "Openstack Rally is required but is not installed.  Aborting."; exit 1; }

echo "Opentack Rally Detected."

sleep 1 #dramatic ;)
echo -n "Checking Openstack Deployments"
echo
#Check which deployment to use and set if required
#echo -n "Which Openstack deployment would you like to test?  The current deployment is "

rally deployment show

read -p "Is the the deployment you would like to test? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]
then
# show and select deployment
echo
rally deployment list

else
echo
rally deployment list
echo -n "Which deployment would you like to use? (name or uid)"
read ENVIRONMENT
echo -n "Switching to Openstack Deployment $ENVIRONMENT"
rally deployment use --deployment $ENVIRONMENT
echo -n "Switched to Rally deployment $ENVIRONMENT"
fi

rally deployment check

echo -n "Executing Odin..."
echo

sleep 1 #Dum Dum Duhhhhh...

#Set up the work directory
mkdir -p ~/odin

#Clean timestamps file
> ~/odin/odin-timestamps.dat

#Execute test plans
for (( c=$START; c<=$END; c++ ))
do
        echo -n "Executing Test $c"
	#Restart all Openstack services prior to testing
	#TODO - MM-DD-YYYY-TIME format, EPOCH is ugly
	timestamp=$(date +%s)	
	echo "$timestamp - Openstack service restart issued" >> ~/odin/odin-timestamps.dat
	echo -n "Restarting Openstack Services.  This may take awhile depending on the size of your environment."
	bash -c ./force_cleanup.sh
        echo -n "Cleanup completed. Cooling off to stabilize the environment before testing. This wait period will allow newly started services to catch up to prevent us from artificially influencing the test results."  
	sleep 30
	echo "Starting Task $c"
        echo "Task $c started at $timestamp" >> ~/odin/odin-timestamps.dat
        rally --debug task start --task ./odin-nimbus-qa-$c.json > ~/odin/rally-nimbus-qa-$c.out
        echo "Task $c completed at $timestamp" >> ~/odin/odin-timestamps.dat
	echo
	echo -n "Task $c completed.  cleaning up outliers..."
	bash -c ./opt/odin/force_cleanup.sh >> ~/odin/rally-nimbus-qa-$c.out
	echo
	echo "Rally is clean now."
	echo
	
        
done

#TODO - list task UIDs in pretty format for each test that was run.  Display in console and write to timestamps log.
#Show task list
rally task list

#Wrap it up 
echo
echo -n "Odin Test Plan Completed.  Please refer to your home directory for the logs and test uids for report generation."
echo
