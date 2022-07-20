Vagrant.require_version ">= 2.0.0"

if ENV['OS'] == "centos" then
  if ENV['VERSION'] == "9" then
    VM_IMG = "generic/centos9s"
    VM_NAME = "vagrant-env-centos9s"
  else
    VM_IMG = "generic/centos8s"
    VM_NAME = "vagrant-env-centos8s"
  end
elsif ENV['OS'] == "rhel" then
  if ENV['VERSION'] == "9" then
    VM_IMG = "generic/rhel9"
    VM_NAME = "vagrant-env-rhel9"
  else
    VM_IMG = "generic/rhel8"
    VM_NAME = "vagrant-env-rhel8"
  end
else # ubuntu
  if ENV['VERSION'] == "jammy" then
    VM_IMG = "generic/ubuntu2204" # 5.15
    VM_NAME = "vagrant-env-jammy"
  elsif ENV['VERSION'] == "impish" then
    VM_IMG = "generic/ubuntu2110" # 5.13
    VM_NAME = "vagrant-env-impish"
  elsif ENV['VERSION'] == "focal" then
    VM_IMG = "generic/ubuntu2004" # 5.4
    VM_NAME = "vagrant-env-focal"
  else
    VM_IMG = "generic/ubuntu1804" # 4.15
    VM_NAME = "vagrant-env-bionic"
  end
end

system("
    if [ #{ARGV[0]} = 'up' ]; then
      if [ ! -f ~/.ssh/id_rsa ]; then
        echo '~/.ssh/id_rsa keys does not exist.'
        ssh-keygen -t rsa -f ~/.ssh/id_rsa
      fi
    fi
")

Vagrant.configure("2") do |config|
  if Vagrant.has_plugin?("vagrant-vbguest")
    config.vbguest.auto_update = false
  end

  if Vagrant.has_plugin?("vagrant-reload")
    config.vbguest.auto_update = false
  end

  # vagrant@VM_NAME
  config.vm.hostname = VM_NAME

  # vagrant plugins
  config.vagrant.plugins = ["vagrant-vbguest", "vagrant-reload"]

  config.vm.define VM_NAME do |cfg|
    cfg.vm.box = VM_IMG
    cfg.vm.provider "virtualbox" do |vb|
      vb.name = VM_NAME
      vb.memory = 4096
      vb.cpus = 4
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    end
  end

  # sync directories
  config.vm.synced_folder "./data", "/home/vagrant/data", owner:"vagrant", group:"vagrant"

  # copy ssh keys
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision :shell, :inline => "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys", run: "always"

  if ENV['OS'] == "centos" then
    if ENV['VERSION'] == "9" then
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "grub-mkconfig -o /boot/grub/grub.cfg"
      config.vm.provision :reload
    end

    # do something

  elsif ENV['OS'] == "rhel" then
    if ENV['VERSION'] == "9" then
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "grub-mkconfig -o /boot/grub/grub.cfg"
      config.vm.provision :reload
    end

    # do something

  else # ubuntu
    if ENV['VERSION'] == "jammy" || ENV['VERSION'] == "impish" then
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "update-grub"
      config.vm.provision :reload
    end

    # do something

  end
end
