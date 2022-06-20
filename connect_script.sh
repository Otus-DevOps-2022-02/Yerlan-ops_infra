#!/bin/bash

ipaddress=$(yc compute instance get reddit-app2 --format json | jq -rC '.network_interfaces' | awk '/one_to_one_nat/ {getline; print $2}' | awk -F \" '{print $2}')

echo "Waiting apps to be installed for about 2 minutes"
sleep 3
echo "."
sleep 5
echo ".."
sleep 7
echo "..."
sleep 10
echo "...."
sleep 11
echo "....."
sleep 12
echo "......"
sleep 13
echo "......."
sleep 14
echo "........"
sleep 15
echo "........."
sleep 16
echo ".........."
portnumber=$(ssh -i ~/.ssh/appuser yc-user@$ipaddress ps aux | awk '$NF=="[reddit]"{n=split($0,t,/[):]/);print t[n-1]}')


args="$ipaddress:$portnumber"
curl -f -s --connect-timeout 5 -s $args > /dev/null && \
echo "#### Reddit app connection successfully tested! ####" || \
echo "######     Connection timed out..     ########"
