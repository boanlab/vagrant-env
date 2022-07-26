#!/bin/bash

NEED_TO_REBOOT=no

. /etc/os-release

if [ ! -x "$(command -v make)" ]; then
    sudo apt-get update
    sudo apt-get -y install build-essential
fi

if [ ! -x "$(command -v wget)" ]; then
    sudo apt-get update
    sudo apt-get -y install wget
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
    wget -O- https://apt.releases.hashicorp.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/hashicorp-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list
    sudo apt-get update
    sudo apt-get -y install vagrant

    # install vagrant plugins
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-reload

    NEED_TO_REBOOT=yes
fi

if [ "$NEED_TO_REBOOT" == "yes" ]; then
    echo "Please reboot the machine"
fi
