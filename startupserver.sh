#!/bin/bash
yc compute instance create \
  --name reddit-app2 \
  --hostname reddit-app2 \
  --memory=4 \
  --create-boot-disk image-folder-id=standard-images,image-family=ubuntu-1604-lts,size=10GB \
  --network-interface subnet-name=default-ru-central1-a,nat-ip-version=ipv4 \
  --metadata serial-port-enable=1 \
  --metadata-from-file user-data=metadata.yaml

ipaddress=$(yc compute instance get reddit-app2 --format json | jq -rC '.network_interfaces' | awk '/one_to_one_nat/ {getline; print $2}' | awk -F \" '{print $2}') && \
ssh-keyscan -H $ipaddress >> ~/.ssh/known_hosts && echo "a new VM ipaddress's fingerprint to ssh-list was added"

for n in {1..15}
	do
		#scrippy=$(ssh -o StrictHostKeyChecking=accept-new -i ~/.ssh/appuser yc-user@$ipaddress pidof -x run_scripts)
		scrippy=$(ssh -i ~/.ssh/appuser yc-user@$ipaddress ps -a | grep run_scripts | awk '{print $1}')
		sleep 10
		if [ "$scrippy" != "" ]; then
			echo "Installation script commencing has been spotted ..."
			for i in {1..15}
				do
					scrippy=$(ssh -i ~/.ssh/appuser yc-user@$ipaddress ps -a | grep run_scripts | awk '{print $1}')
					sleep 10
					if [ "$scrippy" == "" ]; then
					echo "Installation script has been finished ... "
					break
					fi
				done
		fi

	done & PID=$!
	i=1
sp="/-\|"
echo -n ' '
while [ -d /proc/$PID ]
do
  printf "\b${sp:i++%${#sp}:1}"
  sleep 0.3
done


sh connect_script.sh


# ssh-keyscan -H <ip-address> >> ~/.ssh/known_hosts
# -o StrictHostKeyChecking=accept-new
# -o StrictHostKeyChecking=no
