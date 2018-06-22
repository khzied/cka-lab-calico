#!/bin/bash
set -x

sudo yum -y install make git
sudo easy_install pip
sudo pip install docker-py

sudo kubeadm init --config /vagrant/kube/kubeadm-config.yml

mkdir -p $HOME/.kube
sudo cp -i /etc/kubernetes/admin.conf $HOME/.kube/config
sudo chown $(id -u):$(id -g) $HOME/.kube/config

kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/rbac-kdd.yaml
kubectl apply -f https://docs.projectcalico.org/v3.1/getting-started/kubernetes/installation/hosted/kubernetes-datastore/calico-networking/1.7/calico.yaml

echo 'source <(kubectl completion bash)' >> $HOME/.bashrc
