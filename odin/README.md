Odin Nimbus QA Scale Test Script

author:  James Scollard
email:   jscollar@cisco.com

 Copyright 2015 Cisco Systems, Inc.  All rights reserved.

    Licensed under the Apache License, Version 2.0 (the "License"); you may
    not use this file except in compliance with the License. You may obtain
    a copy of the License at

         http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS, WITHOUT
    WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the
    License for the specific language governing permissions and limitations
    under the License.


A consolidated Openstack Rally test plan that provides a repeatable gold standard for testing any environment that produces baseline, load, and overload performance metrics.  The Nimbus Odin test plan will achieve the following objectives:

- A single test run will execute tests against every applicable user story for an environment in a single run at a predetermined standard scale.

- Each test run will produce a single multi-function result set.
Multiple test runs with differing scale values will be output to a single HTML report using built in Rally reporting features

- All environments will use the same set of test plan configuration files and produce apples to apples result sets where apples exist in the environment.

Odin Test Plan Functions (listed in order of execution)

- L2 Ping - This test will create hosts on a shared network space with L2 adjacency and record the results of instance to instance communications for baseline network performance measurement inside the overlay.  This test measures instance creation, port creation, port attachment, round trip network latency, and the amount of time it takes to tear instances down.

- L3 ping - This test will create hosts on a floating/routed network space and record the results of instance to instance communication between them for L3 agent performance measurement across the overlays.  This test measures instance creation, port creation, port attachment, L3 agent creation and assignment, round trip network latency through the L3 agent, and the amount of time it takes to tear everything back down again.

- Boot from Volume - This test will create Cinder (Cisco Ceph) volumes and launch instances that use those volumes as their root disk, measuring the performance of the storage backend for instance creation.  iPerf testing of these instances for disk performance measurements are very useful for capacity planning, but I have not found a way to nest this function into the boot_from_created_volume function yet.  WIP

- Boot and attach Volume - This test will create and instance, create a Cinder (Cisco Ceph) volume, and then attach that volume to the instance as an additional disk, measuring the performance of the storage backend for volume creation and attachment.  Results will show the amount of time it takes to perform creation, attachment, detachment, and deletion operations on Cinder volumes at scale. iPerf testing of these instances for disk performance measurements are very useful for comparison against the previous test, but I have not found a way to nest this function into the attach_created_volume function yet.  WIP

- iPerf VM Test - This test will create multiple instances and run exhaustive performance tests on them to drive up resource utilization for "stress testing" the environment, while producing metrics that will quantify its performance characteristics under load.  These results should allow for near linear forecasting of resources needed for a given customer workload and allow us to translate workload resource requirements directly to hypervisor BOM documents.  Results of this test will show processor, disk, memory, and network performance from the perspective of the instances when the infrastructure is under various loads.

- IPv6 - This test will create instances with IPv6 Neutron ports attached and measure the performance characteristics of IPv6 overlay instance networking, providing measurements for comparison against IPv4 L2 and L3 configurations.  The result set will indicate the latency of requests on average across IPv6 overlay networks, the amount of stress placed on the Neutron hypervisor and network agents at various scales, and the number of requests that can be processed simultaneously.  This test currently requires IPv6 subnets be created manually prior to test runs.  We expect these operations to be automated eventually.  This test will measure the performance of creating instances on an IPv6 subnet, run a performance test on each instance, and tear them down again.
LBaaS Testing - This test will create instances and join them to load balancer pools, then initiate communications between them to evaluate the throughput and latency of our load balancers in a given environment with varying numbers of balanced endpoints.  The results of this test will show the performance of load balancers under varying degrees of load to include number of backend hosts being balanced, average latency to fulfill a request to backend instances under various loads, performance effects of large numbers of load balancers on the network, and will indicate the upper limits to these that can be achieved in the environment.

Usage:

Odin requires you to have Rally installed before use.  If Rally is not install it will abort.  Odin also requires there to be at least one Rally deployment configured.  Once Rally is installed you may control which test plans are executed by modifying the start and end variables in the script to match the desired test plans.  Due to the length of time it takes to complete a thorough test plan using Rally it is recommended to install the Linux screen utility and run tests in a screen session in case you are disconnected.

apt-get install -y screen
-or-
yum install -y screen

Extract the tarball to any directory and execute the following to start the tests:

# screen odin-nimbus-qa.sh

Follow the prompts to set the Rally deployment you want to use.  Odin will then iterate over the selected test plan range restarting all Openstack services in the deployment prior to each iteration using a proprietary Ansible playbook.  Odin logs the output of the service restart operations, captures the timestamps for the start and end of each test run for comparison against that captured by external logging and monitoring systems, and logs the debug output of each test plan to ~/odin/.

Odin will list the full table of Rally tests that have been executed for its Rally instance.  You can then generate a consolidated report of all the tests it executed by grabbing the uid for each test from their corresponding log files and issuing the following:

rally task report --tasks <uid1> <uid2> ...<uid15> -out reportName.html


