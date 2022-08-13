#!/bin/bash

ipaddress=$(yc compute instance get reddit-app2 --format json | jq -rC '.network_interfaces' | awk '/one_to_one_nat/ {getline; print $2}' | awk -F \" '{print $2}')
echo $ipaddress
portnumber=0
c=0

while [[ $c -lt 7 ]]

do
  echo "Number: $c"
  ((c++))
  wait
  if [[ $portnumber -gt 0 ]]; then
	echo $portnumber > foo.txt

    break

  fi
  #portnumber=$(ssh -o StrictHostKeyChecking=no -i ~/.ssh/appuser yc-user@$ipaddress ps -aux | awk '$NF=="[reddit]"{n=split($0,t,/[):]/);print t[n-1]}')
  portnumber=$(ssh -i ~/.ssh/appuser yc-user@$ipaddress ps -aux | awk '$NF=="[reddit]"{n=split($0,t,/[):]/);print t[n-1]}')
  wait

done & PID=$!
i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
  sleep 0.3
done
portnumber=$(cat foo.txt)
args="$ipaddress:$portnumber"
echo $args
echo "ipaddress is: " $ipaddress
echo "port is: " $portnumber

curl -f -s --connect-timeout 7 -s $args > /dev/null && \
echo "#### Puma app connection successfully tested! ####" || \
echo "######     Connection timed out..     ########"
