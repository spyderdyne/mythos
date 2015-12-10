#1bin/bash

#provides: clean-slate.sh

source ../set-environment.sh

# delete old host records
/bin/rm -rf $mythos_home/seshat/clients/*

# activate the nuclear option...
/bin/mv $medusa_home/remote-scripts/.nuclear-option.sh $medusa_home/remote-scripts/nuclear-option.sh