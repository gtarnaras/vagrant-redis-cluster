# ##################### Vagrantfile #################################
#
# This is the main Vagrantfile that automates the provisioning of
# VMs and services
#
# ###################################################################

# ##### Set required versions ######

Vagrant.require_version ">= 2.0.0"
require 'yaml'
settings = YAML.load_file 'vagrant.yml'

# ###### Bring up base box #########

Vagrant.configure("2") do |config|
    
    ####### VM 1 Setup  ########
    config.vm.define "redisbasevm1" do |redisbasevm1|
       
        redisbasevm1.vm.box = "bento/ubuntu-18.04"
        redisbasevm1.vm.hostname =  settings['redisbasevm1_name']
        redisbasevm1.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
        end
        redisbasevm1.vm.network :private_network, ip: settings['redisbasevm1ip_address']

        redisbasevm1.vm.provision "file", source: "./templates/clusternodeA/", destination: "/var/tmp/clusternodeconfig"
        redisbasevm1.vm.provision "file", source: "./templates/cluster_scripts/", destination: "/var/tmp/rediscluster_scripts"

        redisbasevm1.vm.provision "ansible_local" do |ansible|
            #https://github.com/hashicorp/vagrant/issues/9796
            ansible.install_mode = "pip"
            ansible.verbose = true
            ansible.playbook = "provision/playbook.yml"
            ansible.limit = "redisbasevm1"
        end

	end

    ####### VM 2 Setup  ########
    config.vm.define "redisbasevm2" do |redisbasevm2|
       
        redisbasevm2.vm.box = "bento/ubuntu-18.04"
        redisbasevm2.vm.hostname =  settings['redisbasevm2_name']
        redisbasevm2.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
        end
        redisbasevm2.vm.network :private_network, ip: settings['redisbasevm2ip_address']

        redisbasevm2.vm.provision "file", source: "./templates/clusternodeB/", destination: "/var/tmp/clusternodeconfig"
        redisbasevm2.vm.provision "file", source: "./templates/cluster_scripts/", destination: "/var/tmp/rediscluster_scripts"

        redisbasevm2.vm.provision "ansible_local" do |ansible|
            #https://github.com/hashicorp/vagrant/issues/9796
            ansible.install_mode = "pip"            
            ansible.verbose = true
            ansible.playbook = "provision/playbook.yml"
            ansible.limit = "redisbasevm2"
        end

	end

    ####### VM 3 Setup  ########
    config.vm.define "redisbasevm3" do |redisbasevm3|
       
        redisbasevm3.vm.box = "bento/ubuntu-18.04"
        redisbasevm3.vm.hostname =  settings['redisbasevm3_name']
        redisbasevm3.vm.provider :virtualbox do |vb|
              vb.customize ["modifyvm", :id, "--memory", "2048", "--cpus", "2"]
        end
        redisbasevm3.vm.network :private_network, ip: settings['redisbasevm3ip_address']

        redisbasevm3.vm.provision "file", source: "./templates/clusternodeC/", destination: "/var/tmp/clusternodeconfig"
        redisbasevm3.vm.provision "file", source: "./templates/cluster_scripts/", destination: "/var/tmp/rediscluster_scripts"

        redisbasevm3.vm.provision "ansible_local" do |ansible|
            #https://github.com/hashicorp/vagrant/issues/9796
            ansible.install_mode = "pip"            
            ansible.verbose = true
            ansible.playbook = "provision/playbook.yml"
            ansible.limit = "redisbasevm3"
        end
        
        # Let's dump some Redis-cluster info
        redisbasevm3.vm.provision "shell" do |s|
            s.args =  settings['redisbasevm3ip_address'], settings['redisbasevm3_master_port']
            s.path = "scripts/check_redis.sh"
        end

        redisbasevm3.vm.provision "shell" do |s|
            s.args =  settings['redisbasevm2ip_address'], settings['redisbasevm2_master_port']
            s.path = "scripts/check_redis.sh"
        end

        redisbasevm3.vm.provision "shell" do |s|
            s.args =  settings['redisbasevm1ip_address'], settings['redisbasevm1_master_port']
            s.path = "scripts/check_redis.sh"
        end

	end

end
