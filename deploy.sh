#!/bin/bash

echo "##############################################"
echo "######      INSTALLING reddit app...    ######"
echo "##############################################"

sudo runuser -l yc-user -c 'git clone -b monolith https://github.com/express42/reddit.git'
sudo runuser -l yc-user -c 'cd reddit && bundle install'
sudo runuser -l yc-user -c 'cd reddit && puma -d'

sleep 10
echo "###############################################"
echo "#####  The reddit app has been installed  #####"
echo "###############################################"

cd ..
