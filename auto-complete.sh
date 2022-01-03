#!/bin/bash

function libs()
{
  if [ "$1" != "" ]; 
  then
    COMPREPLY=($(compgen -W "all xelatex-thesis infrastructure-as-code sidecar-firefox how-to-build-a-Swarmlab-service network-scanning network-adhoc raspi-docker tech-list faq sensor-node ssh-tunneling iptables poc-datacollector help" "${COMP_WORDS[$COMP_CWORD]}"))
  fi
}


complete -F libs ./build.sh
