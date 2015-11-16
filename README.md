Mythos - Omnipotent Scale Testing for Cloud

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

author:  James Scollard

email:  jscollar@cisco.com

source: https://code.launchpad.net/~openstack-tailgate/openstack-tailgate/mythos

slides:  https://docs.google.com/presentation/d/1MPUg2aYflHzPeJAd9w_QcwDNkoPB298IujfRoNgVaik/edit#slide=id.g73a8cba0b_0_88

docs:  pending

Mythos - Supernatural Testing for Cloud

Mythos is a set of projects to perform scale and performance testing in cloud environmnets.  Mythos is
comprised of the following projects:

Janus - Roman god of beginnings, transitions, and endings.

  The utilities in this project deal with cleaning and preparing environments for testing, and
  cleaning up whatever messes and unwanted artifacts they find.

Mania - Roman underworld goddess of sanity.

  Mana/Mania provides tools for verifying an environment to ensure that it is "sane" for testing,
  and identifying what is down so that it can be addressed between test runs.

Medusa - A gorgon (monster) with the ability to turn heroes to stone.

  The Medusa project provides various load and performance testing utilities for "attacking" an
  Openstack deployment.  These tools simulate massive workloads, are highly parallel, and at scale
  are intended to effectively lock up the architecture by generating so much load that it can no
  longer function, in order to identify limits and limiting factors.

Odin - Norse god of war, death, wisdom, magic, and poetry.

  Odin is a set of BASH helpers for loading multiple tests using Openstack Rally.  For the purpose
  scale testing it serves a couple of functions.  First, due to the nature of scale tests, a single
  test plan can run for days.  Staff generally has to presume when a test might finish and
  constantly check on them to ensure they completed to run the next one.  This utility allows a test
  administrator to stack multiple runs into a single batch to execute one after another, allowing
  work to be completed even during off hours.  It's a weekend saver.  Secondly Odin provides a place
  to reset the environment between tests to minimize the effects of previous test runs by starting
  every run from the same freshly started state.  In scale testing it is used to load progressively
  larger test until failures are observed, then ensures that Rally didnt leave a mess behind before
  starting the next run.


Installation:

1.  Check out the Launchpad project into /opt.  You may or may not be required to provide your 
    Launchpad.net credentials to Bazaar for the download to complete.  Future change to this project 
    should include launchpad git support and these instructions will change, but this is what we have 
    for now.  I full tutorial on using bzr with Launchpad is available here:
    
    http://doc.bazaar.canonical.com/latest/en/tutorials/using_bazaar_with_launchpad.html
    
    If you are reading this though, you probably have the code so I wont elaborate here...
    

2.  View the README in /opt/trunk/mythos/images for instructions to install the required software, and 
    to create and upload machine images.


3.  Deploy the images to your cloud.  Once you have access to the medusa-gorgon instance behind it's 
    floating/public ip address, navigate to the same path you used for setup (/opt/trunk/mythos) and 
    view the instrutions for each component.
    
    medusa-gorgon image instances require the following ports open on your firewall/security group
    policy:
    
    -inbound
    8080 - Apache file server for ad-hoc job executions
    8088 - Phoronix Test Suite Admin Portal
    8089 - Phoronix Wb Socket
    22   - SSH access to the server
    
    -outbound
    all
    
    medusa-serpent instances require these ports open:
    
    -inbound
    80 - Apache web server for Siege testing
    22 - (optional) SSH access to your slaves
    
    -outbound
    all
    
    SSH Keys:
    
    In addition to any keys that are set by your cloud platform, medusa SSh keys are installed and added 
    to authorized_keys for oyu as part of the image creation process.  They can be located in the following
    directory:
    
    '/opt/trunk/mythos/images/keys'
    
    id_rsa_medusa
    id_rsa_medusa.pub
    
    Password Auth:
    
    To configure password authentication for your instances you may set this manually using vagrant before 
    uploading your images to the cloud.
    
    Example:
    
    $ vagrant up medusa-gorgon
    $ vagrant ssh medusa-gorgon
    
    ...then follow the procedure for adding a user to the image OS.
    
    
    