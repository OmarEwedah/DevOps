VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "ubuntu/trusty64"

  config.vm.hostname = "jenkins"
  config.vm.provider :virtualbox do |v|
    v.name = "jenkins"
    v.memory = 1024
    v.cpus = 2
  end

  # Enable provisioning with Ansible.
  config.vm.provision "ansible" do |ansible|
    ansible.playbook = "prepare-env.yml"
  end

end
