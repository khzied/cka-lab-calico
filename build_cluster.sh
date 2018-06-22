#!/bin/bash
set -x

# Install Vagrant disk-resize plugin
vagrant plugin install vagrant-disksize

vagrant up

#Fix Kubelet IP on Master
vagrant ssh master -c "echo 'Environment=\"KUBELET_EXTRA_ARGS=--node-ip=192.168.33.20\"' | sudo tee --append  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
vagrant ssh master -c "sudo systemctl daemon-reload"
vagrant ssh master -c "sudo systemctl restart kubelet.service"

#Fix Kubelet IP on Node1
vagrant ssh node1 -c "echo 'Environment=\"KUBELET_EXTRA_ARGS=--node-ip=192.168.33.21\"' | sudo tee --append  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
vagrant ssh node1 -c "sudo systemctl daemon-reload"
vagrant ssh node1 -c "sudo systemctl restart kubelet.service"

#Fix Kubelet IP on Node2
vagrant ssh node2 -c "echo 'Environment=\"KUBELET_EXTRA_ARGS=--node-ip=192.168.33.22\"' | sudo tee --append  /etc/systemd/system/kubelet.service.d/10-kubeadm.conf"
vagrant ssh node2 -c "sudo systemctl daemon-reload"
vagrant ssh node2 -c "sudo systemctl restart kubelet.service"

# Join Kubernetes nodes
join_cmd=$(vagrant ssh master -c "sudo kubeadm token create --print-join-command")
vagrant ssh node1 -c "sudo ${join_cmd}"
vagrant ssh node2 -c "sudo ${join_cmd}"

#Install helm
vagrant ssh master -c "curl -LO https://storage.googleapis.com/kubernetes-helm/helm-v2.9.0-linux-amd64.tar.gz && tar -xvzf helm-v2.9.0-linux-amd64.tar.gz && chmod +x linux-amd64/helm && sudo mv linux-amd64/helm /usr/local/bin/ && rm -rf linux-amd64/ helm-v2.9.0-linux-amd64.tar.gz"
vagrant ssh master -c "kubectl apply -f /vagrant/kube/tiller-role.yml"
vagrant ssh master -c "helm init --service-account tiller"

#Install NFS server
sleep 30
vagrant ssh master -c "kubectl label node node2 disktype=dbdisk"
vagrant ssh node2 -c "sudo mkdir /data"
vagrant ssh master -c "kubectl apply -f /vagrant/kube/nfs-server.yml"

#Install Nginx ingress controller
sleep 60
vagrant ssh master -c "helm install stable/nginx-ingress --name my-nginx --set rbac.create=true --set controller.service.type=NodePort --set controller.service.nodePorts.http=80  --set controller.service.nodePorts.https=443"

#Install metrics server
vagrant ssh master -c "kubectl apply -f /vagrant/kube/metrics-server/"
