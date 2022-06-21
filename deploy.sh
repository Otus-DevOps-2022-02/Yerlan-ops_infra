#!/bin/bash

echo "##############################################"
echo "#######        INSTALLING git...       #######"
echo "##############################################"

sudo apt-get install -y git

sleep 3
echo "##############################################"
echo "######      INSTALLING reddit app...    ######"
echo "##############################################"

git clone -b monolith https://github.com/express42/reddit.git
cd reddit/
sudo bundle install
puma -d

echo "###############################################"
echo "#####  The reddit app has been installed  #####"
echo "###############################################"

cd ..
