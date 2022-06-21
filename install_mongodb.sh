#!/bin/bash

echo "##############################################"
echo "######   add key and repo for mongodb   ######"
echo "##############################################"

wget -qO - https://www.mongodb.org/static/pgp/server-4.4.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/4.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.4.list

echo "##############################################"
echo "######       INSTALLING mongodb...      ######"
echo "##############################################"

sudo apt-get install -y mongodb-org
sudo apt-get update
sudo apt-get upgrade

echo "##############################################"
echo "######        STARTING mongodb...       ######"
echo "##############################################"
sleep 4

sudo systemctl enable mongod
sudo systemctl start mongod


echo "##############################################"
echo "##   mongodb has been installed & started   ##"
echo "##############################################"
