#!/bin/bash

. /etc/os-release

DOCKER_INSTALL=`dirname $(realpath "$0")`

# update repo
sudo apt-get update

# add GPG key
sudo apt-get install -y curl
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -

# add Docker repository
sudo apt-get install -y software-properties-common
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

# update the Docker repo
sudo apt-get update

# make sure we install Docker from the Docker repo
sudo apt-cache policy docker-ce

# install Docker (the oldest version among the versions that Ubuntu supports)
case "$VERSION" in
"18."*)
    sudo apt-get install -y docker-ce=5:18.09.1~3-0~ubuntu-bionic docker-ce-cli=5:18.09.1~3-0~ubuntu-bionic;;
"20.04"*)
    sudo apt-get install -y docker-ce=5:19.03.9~3-0~ubuntu-focal;;
*)
    sudo apt-get install -y docker-ce;;
esac

# configure daemon.json
sudo mkdir -p /etc/docker
cat <<EOF | sudo tee /etc/docker/daemon.json
{
    "exec-opts": ["native.cgroupdriver=systemd"],
    "log-driver": "json-file",
    "log-opts": {
        "max-size": "100m"
    },
    "storage-driver": "overlay2"
}
EOF

# start Docker
sudo systemctl restart docker
sleep 1

# add user to docker
if [[ "$(id -u -n)" = "vagrant" ]]; then
    sudo usermod -aG docker vagrant
else
    sudo usermod -aG docker $USER
fi

# bypass to run docker command
sudo chmod 666 /var/run/docker.sock

# install docker-compose
sudo curl -sL https://github.com/docker/compose/releases/download/1.18.0/docker-compose-`uname -s`-`uname -m` -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
