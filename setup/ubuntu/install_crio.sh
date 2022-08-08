#!/bin/bash

VERSION=1.22

. /etc/os-release

if [ "$VERSION_ID" == "18.04" ]; then
    OS=xUbuntu_18.04
else # 20.04, 22.04
    OS=xUbuntu_20.04
fi

# get signing keys
echo "deb https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable.list
echo "deb http://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable:/cri-o:/$CRIO_VERSION/$OS/ /"|sudo tee /etc/apt/sources.list.d/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION.list

# add repositories
curl -L https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:$CRIO_VERSION/$OS/Release.key | sudo apt-key add -
curl -L https://download.opensuse.org/repositories/devel:/kubic:/libcontainers:/stable/$OS/Release.key | sudo apt-key add -

# install
sudo apt-get update
sudo apt-get install -y cri-o cri-o-runc

# this option is not supported in ubuntu 18.04
if [ "$VERSION_ID" == "18.04" ]; then
    sudo sed -i 's/,metacopy=on//g' /etc/containers/storage.conf
fi

sudo systemctl daemon-reload
sudo systemctl start crio.service
