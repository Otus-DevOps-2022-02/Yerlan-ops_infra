#!/bin/bash

ipaddress=$(yc compute instance get reddit-app4 --format json | jq -rC '.network_interfaces' | awk '/one_to_one_nat/ {getline; print $2}' | awk -F \" '{print $2}')
portnumber=$(ssh -i ~/.ssh/appuser yc-user@$ipaddress ps -aux | awk '$NF=="[reddit]"{n=split($0,t,/[):]/);print t[n-1]}')

args="$ipaddress:$portnumber"
curl -f -s --connect-timeout 7 -s $args > /dev/null && \
echo "#### Reddit app connection successfully tested! ####" || \
echo "######     Connection timed out..     ########"
