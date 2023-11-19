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
    
  ### DB vm  ####
    config.vm.define "db01" do |db01|
      db01.vm.box = "almalinux/9"
      db01.vm.hostname = "db01"
      db01.vm.network "private_network", ip: "192.168.229.15", name: "VirtualBox Host-Only Ethernet Adapter"
      db01.vm.provision "mysql", type: "shell", path: "mysql.sh"
    end
    
  ### Memcache vm  #### 
    config.vm.define "mc01" do |mc01|
      mc01.vm.box = "almalinux/9"
      mc01.vm.hostname = "mc01"
      mc01.vm.network "private_network", ip: "192.168.229.14", name: "VirtualBox Host-Only Ethernet Adapter"
      mc01.vm.provision "memcache", type: "shell", path: "memcache.sh"
    end
    
  ### RabbitMQ vm  ####
    config.vm.define "rmq01" do |rmq01|
      rmq01.vm.box = "almalinux/9"
      rmq01.vm.hostname = "rmq01"
      rmq01.vm.network "private_network", ip: "192.168.229.13", name: "VirtualBox Host-Only Ethernet Adapter"
      rmq01.vm.provision "rabbitmq", type: "shell", path: "rabbitmq.sh"
    end
    
  ### tomcat vm ###
    config.vm.define "app01" do |app01|
      app01.vm.box = "almalinux/9"
      app01.vm.hostname = "app01"
      app01.vm.network "private_network", ip: "192.168.229.12", name: "VirtualBox Host-Only Ethernet Adapter"
      app01.vm.provision "tomcat", type: "shell", path: "tomcat.sh"
    end
     
    
  ### Nginx VM ###
    config.vm.define "web01" do |web01|
      web01.vm.box = "debian9"
      web01.vm.hostname = "web01"
      web01.vm.network "private_network", ip: "192.168.229.11", name: "VirtualBox Host-Only Ethernet Adapter"
      web01.vm.provision "nginx", type: "shell", path: "nginx.sh"  
    end
    
  end
  