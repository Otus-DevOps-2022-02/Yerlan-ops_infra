#!/bin/bash

echo "##############################################"
echo "######   add key and repo for mongodb   ######"
echo "##############################################"

sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 0C49F3730359A14518585931BC711F9BA15703C6
echo " deb [ arch=amd64 ] https://mirror.yandex.ru/mirrors/repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.4 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-3.4.list

echo "##############################################"
echo "######       INSTALLING mongodb...      ######"
echo "##############################################"

sudo apt-get update
sudo apt-get install -y mongodb-org

echo "##############################################"
echo "######        STARTING mongodb...       ######"
echo "##############################################"
sleep 4

sudo systemctl enable mongod --now
sudo systemctl start mongod

echo "##############################################"
echo "##   mongodb has been installed & started   ##"
echo "##############################################"
