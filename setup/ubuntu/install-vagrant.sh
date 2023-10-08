#!/bin/bash

VAGRANT_VERSION=2.3.0

# install wget
sudo apt -y install wget

# download vagrant package
wget https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/vagrant_$VAGRANT_VERSION-1_amd64.deb

# install vagrant
sudo apt -y install ./vagrant_$VAGRANT_VERSION-1_amd64.deb

# rm the vagrant package
rm vagrant_$VAGRANT_VERSION-1_amd64.deb
