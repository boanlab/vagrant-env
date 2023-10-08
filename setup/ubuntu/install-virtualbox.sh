#!/bin/bash

# install wget
sudo apt -y install wget

# download oracle_vbox_2016.asc and register it to the system
wget -O- https://www.virtualbox.org/download/oracle_vbox_2016.asc | sudo gpg --dearmor --yes --output /usr/share/keyrings/oracle-virtualbox-2016.gpg

# install vbox
sudo apt-get update
sudo apt-get install virtualbox-6.1
