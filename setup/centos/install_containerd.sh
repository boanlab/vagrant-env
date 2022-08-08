#!/bin/bash

# remove podman
sudo yum remove -y buildah skopeo podman containers-common atomic-registries container-tools

# remove left-over files
sudo rm -rf /etc/containers/* /var/lib/containers/* /etc/subuid* /etc/subgid*
cd ~ && rm -rf /.local/share/containers/

# disable selinux
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# setup docker repo
sudo dnf -y install dnf-plugins-core
sudo dnf config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

# install containerd
sudo dnf -y install containerd.io

# remove disabled_plugins = ["cri"]
sudo rm /etc/containerd/config.toml

# start containerd
sudo systemctl enable containerd
sudo systemctl restart containerd
