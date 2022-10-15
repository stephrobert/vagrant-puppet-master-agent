# -*- mode: ruby -*-
# vi: set ft=ruby :
ENV['VAGRANT_NO_PARALLEL'] = 'yes'
Vagrant.configure("2") do |config|
  base_ip_str = "10.240.0.1"
  number_master = 1 # Number of master
  cpu_master = 2
  mem_master = 3072
  number_node = 1 # Number of nodes
  cpu_node = 1
  mem_node = 1024
  config.vm.box = "generic/ubuntu2204" # Image for all installations

  # Compute nodes
  number_machines = number_master + number_node - 1

  nodes = []
  (0..number_machines).each do |i|
    case i
      when 0..number_master - 1
        nodes[i] = {
          "name" => "master#{i}",
          "ip" => "#{base_ip_str}#{i}"
        }
      when number_master..number_machines
        nodes[i] = {
          "name" => "node#{i-number_master}",
          "ip" => "#{base_ip_str}#{i}"
        }
    end
  end

# Provision VM
  nodes.each do |node|
    config.hostmanager.enabled = true
    config.hostmanager.manage_host = true
    config.vm.allow_fstab_modification = true
    config.vm.define node["name"] do |machine|
      machine.vm.hostname = "puppet.%s" % node["name"]
      machine.vm.provider "libvirt" do |lv|
        lv.driver = "kvm"
        if (node["name"] =~ /master/)
          lv.cpus = cpu_master
          lv.memory = mem_master
        else
          lv.cpus = cpu_node
          lv.memory = mem_node
        end
      end
      machine.vm.network "private_network", ip: node["ip"]
      if (node["name"] =~ /master/)
          config.vm.synced_folder "puppet", "/etc/puppetlabs/code/environments/developpement/", type: "nfs", nfs_udp: false, mount_options: ['actimeo=2']
      else
        machine.vm.synced_folder '.', '/vagrant', disabled: true
      end
      machine.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbooks/provision.yml"
        ansible.groups = {
          "masters" => ["master[0:#{number_master-1}]"],
          "nodes" => ["node[0:#{number_node-1}]"],
          "puppet:children" => ["masters", "nodes"],
          "all:vars" => {
            "base_ip_str" => "#{base_ip_str}",
            "number_master" => "#{number_master-1}"
          }
        }
      end
    end
  end
  config.push.define "local-exec" do |push|
    push.inline = <<-SCRIPT
      ansible-playbook -i .vagrant/provisioners/ansible/inventory/vagrant_ansible_inventory playbooks/init-puppet.yml -u vagrant
    SCRIPT
  end
end