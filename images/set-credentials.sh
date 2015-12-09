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
# Sets the access credentials that will be assigned to the control access to
# testing and reporting features.

#Read-Only user credentials
echo "Please input the Read-Only User Name you want to use for viewing reports.  Do not use spaces: "
read user_name_float
sed -i "s/replace_results_user_name/$user_name_float/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp"
echo "Please input the Read-Only User's Password: "
read user_pass_float
sed -i "s/replace_results_user_pass/$user_pass_float/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp"
echo "The Read-Only user has been successfully set to $user_name_float with password $user_pass_float."


#Admin user credentials
echo "Please input the Administrative User Name you want to use for viewing reports.  Do not use spaces: "
read admin_name_float
sed -i "s/replace_results_admin_name/$admin_name_float/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp"
echo "Please input the Administrative User's Password: "
read admin_pass_float
sed -i "s/replace_results_admin_pass/$admin_pass_float/g" "medusa_gorgon/modules/medusa_gorgon/manifests/init.pp"
echo "The Administrative user has been successfully set to $user_name_float with password $user_pass_float."


echo "You have successfully set the access credentials for Medusa Services.  Keep them safe..."