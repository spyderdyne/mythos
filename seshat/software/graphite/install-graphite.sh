#!/bin/bash

#Check for required software and install if needed (Ubuntu only at the moment)
if [ $(dpkg-query -W -f='${Status}' graphite-web 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
  apt-get install -y graphite-web
fi

if [ $(dpkg-query -W -f='${Status}' graphite-carbon 2>/dev/null | grep -c "ok installed") -eq 0 ];
  then
  apt-get install -y graphite-carbon
fi