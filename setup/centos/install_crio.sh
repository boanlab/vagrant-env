#!/bin/bash

VERSION=1.22

# remove podman
sudo yum remove -y buildah skopeo podman containers-common atomic-registries docker container-tools

# remove left-over files
sudo rm -rf /etc/containers/* /var/lib/containers/* /etc/docker /etc/subuid* /etc/subgid*
cd ~ && rm -rf /.local/share/containers/

# disable selinux
sudo sed -i 's/^SELINUX=enforcing$/SELINUX=permissive/' /etc/selinux/config

# setup repo
sudo dnf -y install 'dnf-command(copr)'
sudo dnf -y copr enable rhcontainerbot/container-selinux
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable/CentOS_8/devel:kubic:libcontainers:stable.repo
sudo curl -L -o /etc/yum.repos.d/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo https://download.opensuse.org/repositories/devel:kubic:libcontainers:stable:cri-o:${VERSION}/CentOS_8/devel:kubic:libcontainers:stable:cri-o:${VERSION}.repo
sudo yum install -y cri-o cri-tools containernetworking-plugins

sudo systemctl daemon-reload
sudo systemctl enable --now crio
