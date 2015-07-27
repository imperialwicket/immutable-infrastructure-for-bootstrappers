# -*- mode: ruby -*-
# vi: set ft=ruby :
Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.hostname = "ii4bootstrappers"
  # Just setting a vm name for consistency
  config.vm.define "ii4bootstrappers" do |ii|
  end

  # The key update is breaking ssh for me...
  config.ssh.insert_key = false

  # Share Asgard from vm:8080 to host:8181
  # just in case anyone is running tomcat on host
  config.vm.network :forwarded_port, guest: 8080, host: 8181

  # Configuring with shell for simplicity
  config.vm.provision "shell", path: "bootstrap.sh"

  # Up memory a bit, tweak to preference
  config.vm.provider :virtualbox do |vb|
    #vb.gui = true
    vb.customize ["modifyvm", :id, "--memory", "768"]
    # Rename the virtualbox machine name
    vb.name = "ii4bootstrappers"
  end
end 
