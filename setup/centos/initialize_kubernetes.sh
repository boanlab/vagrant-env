#!/bin/bash

# set default
if [ "$CNI" == "" ]; then
    CNI=cilium
fi

# check supported CNI
if [ "$CNI" != "flannel" ] && [ "$CNI" != "weave" ] && [ "$CNI" != "calico" ] && [ "$CNI" != "cilium" ]; then
    echo "Usage: CNI={flannel|weave|calico|cilium} CRI_SOCKET=unix:///path/to/socket_file MASTER={true|false} $0"
    exit
fi

# reload env
. ~/.bashrc

# turn off swap
sudo swapoff -a

# activate br_netfilter
sudo modprobe br_netfilter
sudo bash -c "echo '1' > /proc/sys/net/bridge/bridge-nf-call-iptables"
sudo bash -c "echo 'net.bridge.bridge-nf-call-iptables=1' >> /etc/sysctl.conf"

# configure selinux labels
sudo mkdir -p /var/lib/etcd/
sudo mkdir -p /etc/kubernetes/pki/
sudo chcon -R -t svirt_sandbox_file_t /var/lib/etcd
sudo chcon -R -t svirt_sandbox_file_t /etc/kubernetes/

# initialize the master node
if [ "$CNI" == "calico" ]; then
    sudo kubeadm init --pod-network-cidr=192.168.0.0/16 | tee -a ~/k8s_init.log
else # weave, flannel, cilium
    sudo kubeadm init --pod-network-cidr=10.244.0.0/16 | tee -a ~/k8s_init.log
fi

sleep 15

# make kubectl work for non-root user
if [[ -d /home/vagrant ]]; then
    mkdir -p /home/vagrant/.kube
    sudo cp -i /etc/kubernetes/admin.conf /home/vagrant/.kube/config
    sudo chown vagrant:vagrant /home/vagrant/.kube/config
    export KUBECONFIG=/home/vagrant/.kube/config
    echo "export KUBECONFIG=/home/vagrant/.kube/config" | tee -a /home/vagrant/.bashrc
else
    [[ ! -d $HOME/.kube ]] && mkdir $HOME/.kube
    [[ -f $HOME/.kube/config ]] && cp $HOME/.kube/config $HOME/.kube/config.bak
    sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
    sudo chown $USER:$USER $HOME/.kube/config
    export KUBECONFIG=$HOME/.kube/config
    echo "export KUBECONFIG=$HOME/.kube/config" | tee -a ~/.bashrc
fi

if [ "$CNI" == "flannel" ]; then
    # install a pod network (flannel)
    kubectl apply -f https://raw.githubusercontent.com/flannel-io/flannel/v0.17.0/Documentation/kube-flannel.yml
elif [ "$CNI" == "weave" ]; then
    # install a pod network (weave)
    export kubever=$(kubectl version | base64 | tr -d '\n')
    kubectl apply -f "https://cloud.weave.works/k8s/net?k8s-version=$kubever"
elif [ "$CNI" == "calico" ]; then
    # install a pod network (calico)
    kubectl apply -f https://projectcalico.docs.tigera.io/manifests/calico.yaml
elif [ "$CNI" == "cilium" ]; then
    # install a pod network (cilium)
    curl -L --remote-name-all https://github.com/cilium/cilium-cli/releases/latest/download/cilium-linux-amd64.tar.gz{,.sha256sum}
    sha256sum --check cilium-linux-amd64.tar.gz.sha256sum
    sudo tar xzvfC cilium-linux-amd64.tar.gz /usr/local/bin
    rm cilium-linux-amd64.tar.gz{,.sha256sum}
    /usr/local/bin/cilium install
fi

if [ "$MASTER" == "true" ]; then
    # disable master isolation (due to the lack of resources)
    kubectl taint nodes --all node-role.kubernetes.io/master-
fi
