Medusa is licesed under the Apache V2 license and is free to use.

NOTE --- You will need to create your neutron subnets with the address of your
public DNS server containing the record for your master server's floating IP address!!!

example:  neutron subnet-create ... --dns-nameservers list=true 123.456.789.1

This server needs to provide the DNS record for the Medusa master instance.  Please
identify and reserve the floating ip address you will be using before creating
tenant subnets.

example: xyz.medusa.cloud.com 1.2.3.1


