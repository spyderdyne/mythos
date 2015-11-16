
#!/bin/bash

    echo "Copying Scripts"
    sleep 2
    pscp -h /opt/trunk/mythos/medusa/discovery/ip_addresses.dat -O UserKnownHostsFile=/dev/null -O StrictHostKeyChecking=no -l cloud-user -t 200 /opt/trunk/mythos/medusa/siege/siege-slave-config.sh /tmp/siege-slave-config.sh &
        
    echo "Firing Remote Scripts"
    sleep 2
    pssh -h /opt/trunk/mythos/medusa/discovery/ip_addresses.dat -O UserKnownHostsFile=/dev/null -O StrictHostKeyChecking=no -l cloud-user -t 200 'sudo /tmp/siege-slave-config.sh'

    echo "Slave Configurations Complete..."
    sleep 2
    echo "Firing Snake Charmer"
