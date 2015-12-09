#!/bin/bash -x

echo "Setting globla path variables"

mythos_home=$(cd `dirname "${BASH_SOURCE[0]}"` && pwd)
reporting_home='$mythos_home/seshat/clients/'
medusa_home='$mythos_home/medusa/'
sanity_home='$mythos_home/janus/'
odin_home='$mythos_home/odin/'