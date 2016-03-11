#!/bin/bash

# Default network layout

ENVRC="/PATH/TO/RC/File"                            # path to your RC file
SUBNETADDR="192.168.50.0/24"                        # an arbitrary overlay subnet or nova networks CIDR
IMAGENAME="DESIRED_UUID_GOES_HERE"                  # the UUID of the image you want to use
FLAVOR="DESIRED_UUID_GOES_HERE"                     # the UUID of the flavor you want to use
EXTNETID="DESIRED_UUID_GOES_HERE"                   # the UUID of the public facing network
PUBKEY="/PATH/TO/KEY/FILE"                          # path to the SSH key file you want to access instance with after spawning

for TENANT in {00401..00500}                        # tenant/project ID range to spawn
do
        source ${ENVRC}

        ROUTERNAME="Scale-Router-${TENANT}"
        TENANTNAME="Scale-Tenant-${TENANT}"
        NETNAME="Scale-Network-${TENANT}"
        SUBNAME="Scale-Subnet-${TENANT}"
        PUBKEYNAME="Scale-Key-${TENANT}"

        echo "Creating tenant ${TENANTNAME}"
        TENANTID=`keystone tenant-create --name ${TENANTNAME} | grep id | awk '{print $4}'`

        keystone user-role-add --user ${OS_USERNAME} --role _member_ --tenant ${TENANTID}
        keystone user-role-add --user ${OS_USERNAME} --role admin --tenant ${TENANTID}

        nova quota-update --key-pairs 10200 ${TENANTID}

        export OS_TENANT_NAME=${TENANTNAME}

        nova keypair-add --pub_key ${PUBKEY} ${PUBKEYNAME}
        #nova keypair-add ${PUBKEYNAME} > ${PUBKEYNAME}.pem
        neutron security-group-rule-create default --direction ingress --ethertype IPv4 --protocol icmp --remote-ip-prefix 0.0.0.0/0
        neutron security-group-rule-create default --direction ingress --ethertype IPv4 --protocol tcp --port-range-min 22 --port-range-max 22 --remote-ip-prefix 0.0.0.0/0

        echo "Creating ${ROUTERNAME}"
        neutron router-create ${ROUTERNAME}
        ROUTERID=`neutron router-show --field id ${ROUTERNAME} | grep id | awk '{print $4}'`

        echo "Creating external gateway on ${ROUTERNAME}"
        neutron router-gateway-set ${ROUTERID} ${EXTNETID}

        echo "Creating network ${NETNAME}"
        NETWORKID=`neutron net-create ${NETNAME} | grep "^| id" | awk '{print $4}'`

        echo "Creating subnet ${SUBNAME}"
        neutron subnet-create --enable-dhcp ${NETNAME} ${SUBNETADDR} --name ${SUBNAME}
        SUBNETID=`neutron net-show ${NETNAME} | grep subnets | awk '{print $4}'`

        echo "Adding interface to router"
        neutron router-interface-add ${ROUTERID} subnet=${SUBNETID}
done