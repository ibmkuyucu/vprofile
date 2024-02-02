# -*- mode: ruby -*-
# vi:set ft=ruby sw=2 ts=2 sts=2:

# class VagrantPlugins::ProviderVirtualBox::Action::Network
  # def dhcp_server_matches_config?(dhcp_server, config)
    # true
  # end
# end

HOST_NAME = "dockervpro"
DOMAIN_NAME = "kuyucu.local"
IP_ADDR = "192.168.229.101"

Vagrant.configure("2") do |config|
  config.hostmanager.enabled = true 
  config.hostmanager.manage_host = true
  config.hostmanager.manage_guest = true
  config.hostmanager.ignore_private_ip = false
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end  
  config.vm.box = "debian11"
  config.vm.box_check_update = false
  config.vm.provider "virtualbox" do |v|
    v.customize ["modifyvm", :id, "--audio", "none"]
    v.check_guest_additions = false
  end
  
  config.vm.define "test" do |test|
    test.vm.hostname = HOST_NAME
    test.hostmanager.aliases = [HOST_NAME+"."+DOMAIN_NAME]
    test.vm.provider "virtualbox" do |vb|
      vb.name = HOST_NAME
      vb.memory = 8192
    end
    test.vm.network "private_network", ip: IP_ADDR, name: "VirtualBox Host-Only Ethernet Adapter"
    test.vm.provision "install-docker", type: "shell", path: "scripts/install-docker_apt.sh"
  end

end