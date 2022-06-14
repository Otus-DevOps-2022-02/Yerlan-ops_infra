#!/bin/bash

ipaddress=$(yc compute instance get reddit-app2 --format json | jq -rC '.network_interfaces' | awk '/one_to_one_nat/ {getline; print $2}' | awk -F \" '{print $2}')

echo "The IP address is found:" $ipaddress

portnumber=$(ssh yc-user@$ipaddress '( ps aux | awk -F '[:)]' '/puma/ {print $(NF-1)}')

echo "The port number is spotted:" $portnumber

args="$ipaddress:$portnumber"
curl -f --connect-timeout 5 -s $args && \
echo "##############################################" && \
echo "#### Connection successfully established  ####" && \
echo "##############################################" || \
echo "##############################################"
echo "######     Connection timed out..     ########"
echo "##############################################"
