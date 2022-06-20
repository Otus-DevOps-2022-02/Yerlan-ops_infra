#!/bin/bash
sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com --recv 7568D9BB55FF9E5287D586017AE645C0CF8E292A
sudo apt -y install curl gnupg2 wget unzip wireguard wireguard-tools libc6
curl -fsSL https://www.mongodb.org/static/pgp/server-5.0.asc | sudo apt-key add -
echo "deb [ arch=amd64,arm64 ] https://repo.mongodb.org/apt/ubuntu focal/mongodb-org/5.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-5.0.list
echo "deb http://repo.pritunl.com/stable/apt focal main" | sudo tee /etc/apt/sources.list.d/pritunl.list
sudo ufw disable
sudo apt install -y mongodb-org pritunl
sudo systemctl stop pritunl mongod
sudo systemctl start pritunl mongod
sudo systemctl enable pritunl mongod
sudo apt update
sudo apt upgrade
