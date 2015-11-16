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

GORGON_IMAGE='medusa_gorgon'
GORGON_IMAGE_URI='https://cloud-images.ubuntu.com/vagrant/vivid/current/vivid-server-cloudimg-amd64-vagrant-disk1.box'
SERPENT_IMAGE='medusa_serpent'
SERPENT_IMAGE_URI='https://cloud-images.ubuntu.com/vagrant/vivid/current/vivid-server-cloudimg-amd64-vagrant-disk1.box'

#Configure the environment
#. ../set-environment.sh
#clean_environments
#set_mythos_home
#add_source_variables


source ~/.mythosrc

MYTHOS_HOME='/opt/trunk/mythos'

#configure the final master endpoint
printf "Your new client image will need to know where the master node can\n
be reached.  You can specify an IP address or DNS name now.  If\n
you do not you will need to manually set your images to use the\n
correct address before uploading them to the cloud.  Please see\n
the Mythos project documentation for more information.\n"

read -p "Would you like to set the master address at this time? (Y/n): " set_master_addy
  case $set_master_addy in

    Y|y) ( exec "./set-master-address.sh" ) ;;

    N|n) echo "Please make sure to set it later or your instances will not know who to talk to..." ;;

      *) echo "Please choose Y or n. "
         exit 1
         ;;
  esac

export VAGRANT_DEFUALT_PROVIDER='virtualbox'

#ensure package lists are up to date.  Need a better workaround for this later so we arent running it all the time...
#apt-get update #removed.  need to make a note in the readme that the package lists need to be up to date before executing this script...

#Determine if this system is capable of virtualization, and whether hardware acceleration is supported.

#if egrep -c '(vmx|svm)' /proc/cpuinfo | grep 0
#  then
#   echo "This system is not capable of virtualizing KVM instances.  If you are attempting to virtualize on a virtual machine please make sure this is supported by your hypervisor and your configuration is correct."
#    exit 1
#  else
#    echo "This system is Vanderpool capable.  Continuing."
#fi

#if [ $(dpkg-query -W -f='${Status}' cpu-checker 2>/dev/null | grep -c "ok installed") -eq 0 ];
#  then
#    kvm-ok
#  else
#    apt-get install -y cpu-checker
#    kvm-ok
#fi

#Check for required software and install if needed (Ubuntu only at the moment)
if [ $(dpkg-query -W -f='${Status}' vagrant 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
  apt-get install -y vagrant build-essential
fi

#Install VBox for vagrant image building option
if [ $(dpkg-query -W -f='${Status}' virtualbox 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
  #apt-get install -y qemu-system qemu-kvm libvirt-bin virtinst virt-viewer; >> required by libvirt driver, disabled for vbox
  apt-get install -y virtualbox
fi

#if [ $(dpkg-query -W -f='${Status}' libxslt-dev 2>/dev/null | grep -c "ok installed") -eq 0 ];
#  then
#  apt-get install -y libxslt-dev libxml2-dev libvirt-dev zlib1g-dev; >> more libvirt depends
#fi

#Install git if needed (dib only)
#if [ $(dpkg-query -W -f='${Status}' git 2>/dev/null | grep -c "ok installed") -eq 0 ];
#  then
#  apt-get install -y git;
#fi

#Ensure Vagrant has the required plugins installed
#if vagrant plugin list | grep vagrant-libvirt
#  then
#    echo "vagrant-libvirt plugin is installed.  Moving on..."
#  else
#     apt-get install -y build-essential
#     ln -fs /usr/bin/ld.gold /usr/bin/ld
#     vagrant plugin install vagrant-libvirt
#fi

#if vagrant plugin list | grep vagrant-mutate
#  then
#   echo "vagrant-mutate plugin is installed.  Moving on..."
#  else
#    vagrant plugin install vagrant-mutate
#fi

#Prune the global vagrant indexes to eliminate any leftover wierdness left by troubleshooting
vagrant global-status --prune

#if vagrant plugin list | grep vagrant-mutate
#  then
#   echo "vagrant-cachier plugin is installed.  Moving on..."
# else
#   vagrant plugin install vagrant-cachier
#fi

echo "Creating public/private key pair..."
echo "Skipping until automation is resolved..."
#Create SSH Keys for the images and add to puppet
ssh-keygen -t rsa -P '' -f keys/id_rsa_medusa
#echo -e '\n \n' | ssh-keygen -t rsa -f keys/id_rsa_medusa
ssh-keygen -f keys/id_rsa_medusa -e -m pem > keys/id_rsa_medusa.pem
#Copy keys to paths
cp keys/id_rsa_medusa* medusa_gorgon/modules/medusa_gorgon/files/
cp keys/id_rsa_medusa.pem medusa_serpent/modules/medusa_serpent/files/

#Create Medusa master image
echo "Creating Medusa Gorgon (server) Image"
sleep 3
#Download the image if needed
if vagrant box list | grep $GORGON_IMAGE
  then
    echo "$GORGON_IMAGE exists.  Moving on..."
  else
    echo "Importing Vagrant box $GORGON_IMAGE from '$GORGON_IMAGE_URI'"
    vagrant box add $GORGON_IMAGE $GORGON_IMAGE_URI
    echo "Box $GORGON_IMAGE server image added."
fi

#Mutate the box to libvirt format if another provider
#if vagrant box list $GORGON_IMAGE | grep "$GORGON_IMAGE (libvirt,"
#  then
#    echo "Box $GORGON_IMAGE server image is in libvirt format.  Provisioning..."
#  else
#    vagrant mutate $GORGON_IMAGE libvirt
#    echo "Box $GORGON_IMAGE mutated to libvirt format.  Provisioning..."
#fi


#Create Medusa slave image
echo "Creating Medusa Serpent (client) Image"
sleep 3
##Download the image if needed
if vagrant box list | grep $SERPENT_IMAGE
  then
    echo "$SERPENT_IMAGE exists.  Moving on..."
  else
    echo "Importing Vagrant box $SERPENT_IMAGE_URI from '$SERPENT_IMAGE_URI'"
    vagrant box add $SERPENT_IMAGE $SERPENT_IMAGE_URI
    echo "Box $SERPENT_IMAGE client image added."
fi

#Mutate the box to libvirt format if another provider
#if vagrant box list $SERPENT_IMAGE | grep "$SERPENT_IMAGE (libvirt,"
#  then
#    echo "Box $SERPENT_IMAGE slave image is in libvirt format.  Provisioning..."
#  else
#    vagrant mutate $SLAVE_IMAGE libvirt
#    echo "Box $SERPENT_IMAGE mutated to libvirt format.  Provisioning..."
#fi


echo "Vagrant boxes should be ready to go.  Here is what we have now:"
vagrant box list
sleep 3

echo "Creating Instances and Provisioning Components"


#Bring up the instances with Vagrant
function image_init() {
  for arg in $@
    do
      cd /opt/trunk/mythos/images/$arg/
      vagrant up $arg --provision
      #vagrant halt $arg #comment out for manifest troubleshooting...
      read -p "Convert the image to another format? It is currently a virtualbox machine.  Depending on the source of your image it may not be usable on any other hypervisor. (Y/n) " do_convert
        case $do_convert in
          y|Y ) echo "1 QCOW2 - libvirt"
            echo "2 VMDK  - VMWare"
            echo "3 VPC - HyperV"
            echo "4 QED - KVM"
            echo "5 VDI - Virtualbox"
            echo "6 RAW - Raw Image Format"
            read -p "Which format would you like to convert to? " convert_format

            MACHINE_IMAGE=$(vboxmanage list vms | grep $arg | egrep -m 1 -o [0-9a-f]{8}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{4}-[0-9a-f]{12})

            echo "Powering off $arg virtual machine..."
            vboxmanage controlvm $MACHINE_IMAGE acpipowerbutton
            sleep 5
            echo "setting VM 'pretty name' for $arg"
            vboxmanage modifyvm $MACHINE_IMAGE --name $arg
            echo "Time to convert the clone..."
            vboxmanage clonehd --format RAW '~/VirtualBox\ VMs/$arg/box-disk1.vmdk' /opt/trunk/mythos/images/workspace/$arg.img
            echo "Converting $arg image to RAW format."
            echo "Image $arg renamed from the ugly VBox standard and converted to RAW format.  This file is huge now. Time to convert to final image format..."

            if [ $(dpkg-query -W -f='${Status}' qemu-utils 2>/dev/null | grep -c "ok installed") -eq 0 ];
              then
                apt-get install -y qemu-utils;
              else
                echo "qemu-img and utilities already installed.  Moving on..."
            fi

          perform_conversion

          echo "Removing raw image for $arg to save disk space."
          rm -rf $MYTHOS_HOME/images/workspace/$arg.img
          ;;

          n|N ) echo "Your machines are active.  VBox images are located at ~/Virtualbox VMs/"
          ;;

          *)   echo "Please enter a valid option..."
               exit 1
          ;;
        esac
      done
  }

image_init 'medusa_gorgon' 'medusa_serpent'

#Create Images using DIB
#time DIB_RELEASE=vivid disk-image-create -o $MYTHOS_HOME/images/medusa_gorgon/workspace/medusa_gorgon.qcow2 vm ubuntu
#time DIB_RELEASE=vivid disk-image-create -o $MYTHOS_HOME/images/medusa_serpent/workspace/medusa_serpent.qcow2 vm debian


echo "Medusa Instance Provisioning Steps Completed."
sleep 3


function perform_conversion() {
  case $convert_format in
    1|QCOW2) { qemu-img convert -f raw $MYTHOS_HOME/images/workspace/$arg.img -O qcow2 $MYTHOS_HOME/images/workspace/$arg.qcow2; echo "Converting $arg to QCOW2"; } &
             wait
             echo "Qemulator image copied to workpsace"
             ;;

    2|VMDK)  { qemu-img convert -f raw $MYTHOS_HOME/images/workspace/$arg.img -O vmdk $MYTHOS_HOME/images/workspace/$arg.vmdk; echo "Converting $arg to VMDK"; } &
             wait
             echo "VMWare images copied to workpsace"
             ;;

    3|VPC)   { qemu-img convert -f raw $MYTHOS_HOME/images/workspace/$arg.img -O vpc $MYTHOS_HOME/images/workspace/$arg.vpc; echo "Converting $arg to VPC"; } &
             wait
             echo "HyperV images copied to workpsace"
             ;;

    4|QED)   { qemu-img convert -f raw $MYTHOS_HOME/images/workspace/$arg.img -O qed $MYTHOS_HOME/images/workspace/$arg.qed; echo "Converting $arg to QED"; } &
             wait
             echo "KVM images copied to workpsace"
             ;;

    5|VDI)   { cp ~/Virtualbox \VMs/$arg/$arg.disk1.box $MYTHOS_HOME/images/workspace/$arg.disk1.box; echo "Copying $arg to Workspace"; } &
             wait
             echo "VBox files copied to workspace"
             ;;

    6|RAW)   echo "RAW images were created in the previous step.  Copied to workspace.  Nothing to do..."
             ;;

    *)       echo "Please choose a valid option. (1-6)."
             exit 1
             ;;
    esac
  }

read -p "Would you like to push your images to a cloud environment? (Y/n)" manage_images
  case $manage_images in
        Y|y ) (exec '$MYTHOS_HOME/janus/local/cloud-management/manage-images.sh')
                ;;
        N|n ) echo "Your images are located in $MYTHOS_HOME/images/workspace."
                ;;
        * )     echo "Please answer (Y/n)."
                exit 1
                ;;
  esac

echo "Image Creation and Management Functions Completed."