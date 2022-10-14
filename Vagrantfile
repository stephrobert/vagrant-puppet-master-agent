# -*- mode: ruby -*-
# vi: set ft=ruby :
$script=<<EOF
wget http://apt.puppet.com/puppet7-release-jammy.deb
sudo dpkg -i puppet7-release-jammy.deb
sudo apt update && sudo apt install puppet-agent
puppet module install --modulepath /tmp/vagrant-puppet/modules puppetlabs-stdlib
EOF
Vagrant.configure("2") do |config|
  config.vm.box = "generic/ubuntu2204"
  config.vm.network :forwarded_port, guest: 80, host: 8080
  config.vm.provision "shell", inline: $script
  config.vm.synced_folder("puppet/hiera", "/tmp/vagrant-puppet/hiera")
  config.vm.provision :puppet do |puppet|
    puppet.module_path = ["puppet/modules"]
    puppet.manifests_path = "puppet/manifests"
    puppet.manifest_file  = "init.pp"
    puppet.hiera_config_path = "puppet/hiera/hiera.yaml"
    puppet.working_directory = "/tmp/vagrant-puppet"
    puppet.options = "--verbose --debug "
  end
end
