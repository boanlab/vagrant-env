#!/bin/bash

if [ "$RUNTIME" == "" ]; then
    if [ -S /var/run/docker.sock ]; then
        RUNTIME="docker"
    elif [ -S /var/run/crio/crio.sock ]; then
        RUNTIME="crio"
    else # default
        RUNTIME="containerd"
    fi
fi

# create a single-node K3s cluster
if [ "$RUNTIME" == "docker" ]; then # docker
    CGROUP_SYSTEMD=$(docker info 2> /dev/null | grep -i cgroup | grep systemd | wc -l)
    if [ $CGROUP_SYSTEMD == 1 ]; then
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.9+k3s1" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --docker --kubelet-arg cgroup-driver=systemd" sh -
        [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
    else # cgroupfs
        curl -sfL https://get.k3s.io | INSTALL_K3S_VERSION="v1.23.9+k3s1" K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --docker" sh -
        [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
    fi
elif [ "$RUNTIME" == "crio" ]; then # cri-o
  curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik --container-runtime-endpoint unix:///var/run/crio/crio.sock --kubelet-arg cgroup-driver=systemd" sh -
  [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
else # containerd by default
  curl -sfL https://get.k3s.io | K3S_KUBECONFIG_MODE="644" INSTALL_K3S_EXEC="--disable=traefik" sh -
  [[ $? != 0 ]] && echo "Failed to install k3s" && exit 1
fi

if [[ $(id -u -n) == "vagrant" ]]; then
    mkdir -p /home/vagrant/.kube
    sudo cp /etc/rancher/k3s/k3s.yaml /home/vagrant/.kube/config
    sudo chown -R vagrant:vagrant /home/vagrant/.kube
    echo "export KUBECONFIG=/home/vagrant/.kube/config" | tee -a /home/vagrant/.bashrc
else
    [[ ! -d $HOME/.kube ]] && mkdir $HOME/.kube
    [[ -f $HOME/.kube/config ]] && cp $HOME/.kube/config $HOME/.kube/config.bak
    sudo cp /etc/rancher/k3s/k3s.yaml $HOME/.kube/config
    sudo chown $USER:$USER $HOME/.kube/config
    echo "export KUBECONFIG=$HOME/.kube/config" | tee -a ~/.bashrc
fi

KUBECTL=$(which kubectl 2> /dev/null)
if [ "$KUBECTL" == "" ]; then
    KUBECTL=/usr/local/bin/kubectl
fi

endtime=$(date -ud "10 min" +%s)
while [[ $(date -u +%s) -le $endtime ]]
do
    echo "wait for initialization"
    sleep 15

    status=$($KUBECTL get pods -A -o jsonpath={.items[*].status.phase})
    if [ $(echo $status | grep -v Running | wc -l) -eq 0 ]; then
        echo "Initialized k3s" && exit 0
    fi
done

echo "Failed to initialized k3s"
exit 1
