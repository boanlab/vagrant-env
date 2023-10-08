#!/bin/bash

VAGRANT_VERSION=2.3.0

# install wget
sudo yum -y install wget

# download vagrant package
wget https://releases.hashicorp.com/vagrant/$VAGRANT_VERSION/vagrant_$VAGRANT_VERSION-1.x86_64.rpm

# install vagrant
sudo yum –y localinstall vagrant_$VAGRANT_VERSION-1.x86_64.rpm

# remove the vagrant package
rm vagrant_$VAGRANT_VERSION-1.x86_64.rpm
