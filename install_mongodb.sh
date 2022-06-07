#!/bin/bash

echo "##############################################"
echo "######   add key and repo for mongodb   ######"
echo "##############################################"

wget -qO - https://www.mongodb.org/static/pgp/server-4.2.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.2 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.2.list

echo "##############################################"
echo "######       INSTALLING mongodb...      ######"
echo "##############################################"

sudo apt update
sudo apt upgrade
sudo apt-get install -y mongodb-org

echo "##############################################"
echo "######        STARTING mongodb...       ######"
echo "##############################################"
sleep 4

sudo systemctl enable mongod
sudo systemctl start mongod

echo "##############################################"
echo "###  mongodb has been installed & started  ###"
echo "##############################################"

EOF
