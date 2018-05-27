# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  
  config.vm.box = "ubuntu/xenial64"

  config.vm.network "forwarded_port", guest: 8080, host: 8080
  
  config.vm.synced_folder ".", "/vagrant", disabled: false
    
  config.vm.provider "virtualbox" do |v|
    v.memory = 2048
    v.cpus = 2
  end

  config.vm.provision :shell, path: "install-go-s2i.sh"
  
  config.vm.provision "docker" do |d|
    d.build_image "/vagrant", args: "-t nginx-centos7"
  end
  
  config.vm.provision :shell, inline: "cp /vagrant/daemon.json /etc/docker/daemon.json"
  config.vm.provision :shell, inline: "service docker restart"
    
end
  