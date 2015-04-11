# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|
  config.vm.box = "centos-7-x86_64-nocm"
  config.vm.box_url = "https://gridadmin01.mgmt.unibe.ch/boxes/centos-7-x86_64-virtualbox-nocm.box"
  config.vm.host_name = "localserver"

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.network :forwarded_port, guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  # config.vm.network :private_network, ip: "192.168.33.10"
  config.vm.network :private_network, ip: "192.168.5.10"

  config.vm.provider :virtualbox do |vb|
    vb.gui = false
    vb.customize ["modifyvm", :id, "--name", "localserver"]
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.customize ["modifyvm", :id, "--memory", "512"]
    vb.customize ["setextradata", :id, "VBoxInternal2/SharedFoldersEnableSymlinksCreate/vagrant-root", "1"]
  end

  config.vm.provision "shell", path: "bin/bootstrap.sh"


  # Enable provisioning with Puppet stand alone.  Puppet manifests
  # are contained in a directory path relative to this Vagrantfile.
  # You will need to create the manifests directory and a manifest in
  # the file base.pp in the manifests_path directory.
  #
  #config.vm.provision :puppet do |puppet|
  #  puppet.manifest_file  = "site.pp"
  #  puppet.manifests_path = "puppet/manifests"
  #  puppet.module_path    = "puppet/modules"
  #  puppet.options        = "--verbose"
  #  #puppet.options        = "--verbose --debug"
  #  #facter                = { "operatingsystem" => "Debian" }
  #end
end
