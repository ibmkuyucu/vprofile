# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

  Vagrant.configure("2") do |config|
    config.vm.box_check_update = false
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    if Vagrant.has_plugin?("vagrant-vbguest")
      config.vbguest.auto_update = false
    end
    config.vm.provider "virtualbox" do |v|
      v.cpus = 2
      v.customize ["modifyvm", :id, "--audio", "none"]
      v.linked_clone = true
      v.check_guest_additions = false
    end
    
  ### Jenkins VM  ####
    config.vm.define "jenkins" do |jenkins|
      jenkins.vm.provider "virtualbox" do |v|
        v.name = "ci-jenkins"
        v.memory = 4096
      end
      jenkins.vm.box = "debian11"
      jenkins.vm.hostname = "jenkins"
      jenkins.vm.network "private_network", ip: "192.168.229.14", name: "VirtualBox Host-Only Ethernet Adapter"
      jenkins.vm.network "forwarded_port", id: "web", guest: 8080, host: 9080
      jenkins.vm.provision "jenkins", type: "shell", path: "scripts/jenkins.sh"
    end
    
  ### Nexus VM  #### 
    config.vm.define "nexus" do |nexus|
      nexus.vm.provider "virtualbox" do |v|
        v.name = "ci-nexus"
        v.memory = 4096
      end
      nexus.vm.box = "debian11"
      nexus.vm.hostname = "nexus"
      nexus.vm.network "private_network", ip: "192.168.229.13", name: "VirtualBox Host-Only Ethernet Adapter"
      nexus.vm.provision "nexus", type: "shell", path: "scripts/nexus.sh"
    end
    
  ### Sonar VM  ####
    config.vm.define "sonar" do |sonar|
      sonar.vm.provider "virtualbox" do |v|
        v.name = "ci-sonar"
        v.memory = 4096
      end
      sonar.vm.box = "debian11"
      sonar.vm.hostname = "sonar"
      sonar.vm.network "private_network", ip: "192.168.229.12", name: "VirtualBox Host-Only Ethernet Adapter"
      sonar.vm.provision "sonar", type: "shell", path: "scripts/sonar.sh"
      sonar.vm.provision :reload
    end
  
    ### Nginx VM ###
    # config.vm.define "nginx" do |nginx|
    #   nginx.vm.provider "virtualbox" do |v|
    #     v.name = "ci-nginx"
    #   end
    #   nginx.vm.box = "debian9"
    #   nginx.vm.hostname = "nginx"
    #   nginx.vm.network "private_network", ip: "192.168.229.11", name: "VirtualBox Host-Only Ethernet Adapter"
    #   nginx.vm.network "forwarded_port", id: "web", guest: 80, host: 9080
    #   nginx.vm.provision "nginx", type: "shell", path: "scripts/nginx.sh"  
    # end
  
  end
  