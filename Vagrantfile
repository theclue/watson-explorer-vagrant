# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

# Configuration parameters
ram = 4096                            # Ram in MB for each VM
secondaryStorage = 150                # Size in GB for the secondary virtual HDD
privateNetworkIp = "10.10.10.50"      # IP for the private network between VMs

# Do not edit below this line
# --------------------------------------------------------------
privateSubnet = privateNetworkIp.split(".")[0...3].join(".")
privateStartingIp = privateNetworkIp.split(".")[3].to_i

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos65-x86_64-20140116"
  config.vm.box_url = "https://github.com/2creatives/vagrant-centos/releases/download/v6.4.2/centos64-x86_64-20140116.box"
  config.vm.define "we-engine" do |master|
    master.vm.network :public_network
    master.vm.network :private_network, ip: "#{privateSubnet}.#{privateStartingIp}", virtualbox__intnet: "we-network"
    master.vm.hostname = "we-engine"

    master.vm.provider "vmware_fusion" do |v|
      v.vmx["memsize"]  = "#{ram}"
    end
    master.vm.provider :virtualbox do |v|
      v.name = "Watson Explorer 4.0 - Engine"
      v.customize ["modifyvm", :id, "--memory", "#{ram}"]
      file_to_disk = File.realpath( "." ).to_s + "/" + master.vm.hostname.to_s + "_secondary_hdd.vdi"
      if ARGV[0] == "up" && ! File.exist?(file_to_disk)
        v.customize ['storagectl', :id, '--name', 'SATA', '--portcount', 2, '--hostiocache', 'on']
        v.customize ['createhd', '--filename', file_to_disk, '--format', 'VDI', '--size', "#{secondaryStorage * 1024}"]
        v.customize ['storageattach', :id, '--storagectl', 'SATA', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', file_to_disk]
      end
    end

    master.vm.provision :shell, :path => "provision_for_mount_disk.sh"
    master.vm.provision :shell, :path => "we-engine.sh"
  end
end
