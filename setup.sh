#!/bin/bash

NEED_TO_REBOOT=no

. /etc/os-release

if [ ! -x "$(command -v make)" ]; then
    sudo apt-get update
    sudo apt-get -y install build-essential
fi

if [ ! -x "$(command -v vboxmanage)" ]; then
    # install virtualbox
    wget -q https://www.virtualbox.org/download/oracle_vbox_2016.asc -O- | sudo apt-key add -
    wget -q https://www.virtualbox.org/download/oracle_vbox.asc -O- | sudo apt-key add -
    sudo add-apt-repository "deb [arch=amd64] http://download.virtualbox.org/virtualbox/debian $(lsb_release -cs) contrib"
    sudo apt-get update
    sudo apt-get -y install virtualbox-6.1

    NEED_TO_REBOOT=yes
fi

if [ ! -x "$(command -v vagrant)" ]; then
    # install vagrant
    wget https://releases.hashicorp.com/vagrant/2.2.9/vagrant_2.2.9_x86_64.deb
    sudo dpkg -i vagrant_2.2.9_x86_64.deb
    sudo apt-get -y install nfs-kernel-server
    rm vagrant_2.2.9_x86_64.deb

    # install vagrant plugins
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-reload

    NEED_TO_REBOOT=yes
fi

if [ "$NEED_TO_REBOOT" == "yes" ]; then
    echo "Please reboot the machine"
fi
