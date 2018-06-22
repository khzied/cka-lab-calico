# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.disksize.size = '50GB'


  config.vm.define "master" do |master|
    master.vm.hostname = "master"
    master.vm.box = "centos/7"
    master.vm.network "private_network", ip: "172.16.33.20"
    master.vm.provision "shell", path: "provision/docker_install.sh"
    master.vm.provision "shell", path: "provision/kubernetes_install.sh"
    master.vm.provision "shell", path: "provision/master_init.sh", privileged: false
    for p in [:virtualbox, :libvirt] do
      master.vm.provider p do |provider|
        provider.memory = 2048
        provider.cpus = 2
      end
    end
  end

  config.vm.define "node1" do |node1|
    node1.vm.hostname = "node1"
    node1.vm.box = "centos/7"
    node1.vm.network "private_network", ip: "172.16.33.21"
    node1.vm.provision "shell", path: "provision/docker_install.sh"
    node1.vm.provision "shell", path: "provision/kubernetes_install.sh"
    for p in [:virtualbox, :libvirt] do
      node1.vm.provider p do |provider|
        provider.memory = 4068
        provider.cpus = 4
      end
    end
  end

  config.vm.define "node2" do |node2|
    node2.vm.hostname = "node2"
    node2.vm.box = "centos/7"
    node2.vm.network "private_network", ip: "172.16.33.22"
    node2.vm.provision "shell", path: "provision/docker_install.sh"
    node2.vm.provision "shell", path: "provision/kubernetes_install.sh"
    for p in [:virtualbox, :libvirt] do
      node2.vm.provider p do |provider|
        provider.memory = 4068
        provider.cpus = 3
      end
    end
  end

end
