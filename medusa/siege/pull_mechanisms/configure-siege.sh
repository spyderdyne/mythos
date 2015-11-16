#!/bin/bash

if grep -q MYTHOS_HOME "~/.mythsrc"
  then
    source ~/.mythosrc
  else
    . ../../../set-environment.sh
    clean_environments
    set_mythos_home
    source ~/.mythosrc
fi

$MYTHOS_HOME/medusa/discovery/searchlight.sh

$MYTHOS_HOME/medusa/discovery/medusa-random.sh

cp $MYTHOS_HOME/medusa/discovery/serpents.dat $MYTHOS_HOME/medusa/siege/serpents.dat