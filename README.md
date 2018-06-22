Certified Kubernetes Administrator (CKA) Lab 
============================================

Vagrant setup which bootstraps a Kubernetes cluster using Kubeadm, deploys Helm,  NFS server for persistent Volumes, Metrics Server  and  Nginx ingress controller.

Requirements
------------
- Vagrant and Virtualbox installed.
- At leasts 8GB of memory on your base machine.
- At least 4 cpu cores
- At least 100GB of space

Build cluster
-------------

Execute: `./build_cluster.sh` 

This script creates three virtual machines:

  | name   | IP            |
  | ------ | ------------- |
  | master | 172.16.33.20 |
  | node1  | 172.16.33.21 |
  | node2  | 172.16.33.22 |


To access this machines just use `vagrant ssh <machine>`, for example:

  `vagrant ssh master` or `vagrant ssh node1`


Nginx ingress
-------------
Nginx ingress is using NodePort and running on port 80 and 443


Access Kubernetes
-----------------

The vagrant user on master node has admin credential for kubernetes.
So you can use kubectl on a easy way.

Example:

```
[ikanse@k8s cka-lab]$ vagrant ssh master
Last login: Mon Jun 11 10:05:52 2018 from 10.0.2.2

[vagrant@master ~]$ kubectl get nodes
NAME      STATUS    ROLES     AGE       VERSION
master    Ready     master    32m       v1.10.5
node1     Ready     <none>    27m       v1.10.5
node2     Ready     <none>    27m       v1.10.5
```

Shutdown
--------

To stop all the machines execute: `vagrant halt`


Boot up
-------

To boot up the Kubernetes cluster use: `vagrant up`


Destroy
-------

If you want to destroy the Kubernetes cluster to build it again or just to free resources,
use: `vagrant destroy`
