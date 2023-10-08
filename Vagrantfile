Vagrant.require_version ">= 2.0.0"

ENV_NAME = ENV['PREFIX'] || "vagrant-env"

OS_NAME    = ENV['OS'] || "ubuntu"
OS_VERSION = ENV['VERSION'] || "22.04"

NUM_OF_VCPUS = 4
SIZE_OF_VMEM = 4096

# disable the following lines
# if you want to statically set the environment.
# OS_NAME = "ubuntu"
# OS_VERSION = "22.04"

# check if the given os is supported
if OS_NAME == "" then
  OS_NAME = "ubuntu" # by default
elsif OS_NAME != "ubuntu" && OS_NAME != "centos" then
  puts "Unkonwn OS_NAME: ENV['OS'] = { 'ubuntu' | 'centos' }"
  abort
end

# check if the given version is supported
if OS_NAME == "ubuntu" then
  if OS_VERSION == "" then
    OS_VERSION = "22.04"
  elsif (OS_VERSION != "18.04" && OS_VERSION != "20.04" && OS_VERSION != "22.04") then
    puts "Unknown OS_VERSION: ENV['VERSION'] = { '18.04' | '20.04' | '22.04' }"
    abort
  end
elsif OS_NAME == "centos" then
  if OS_VERSION == "" then
    OS_VERSION = "9"
  elsif OS_NAME == "centos" && (OS_VERSION != "8" && OS_VERSION != "9") then
    puts "Unknown OS_VERSION: ENV['VERSION'] = { '8' | '9' }"
    abort
  end
end

puts "OS_NAME: " + OS_NAME + ", OS_VERSION: " + OS_VERSION

## == ##

# set the specific Ubuntu image and VM name
if OS_NAME == "ubuntu" then
  if OS_VERSION == "22.04" then
    VM_IMG = "generic/ubuntu2204"
    VM_NAME = ENV_NAME + "-ubuntu2204"
  elsif OS_VERSION == "20.04" then
    VM_IMG = "generic/ubuntu2004"
    VM_NAME = ENV_NAME + "-ubuntu2004"
  elsif OS_VERSION == "18.04" then
    VM_IMG = "generic/ubuntu1804"
    VM_NAME = ENV_NAME + "-ubuntu1804"
  end
elsif OS_NAME == "centos" then
  if OS_VERSION == "9" then
    VM_IMG = "generic/centos9s"
    VM_NAME = ENV_NAME + "-centos9s"
  elsif OS_VERSION == "8" then
    VM_IMG = "generic/centos8s"
    VM_NAME = ENV_NAME + "-centos8s"
  end
end

## == ##

# create ssh keys if needed
system("
    if [ #{ARGV[0]} = 'up' ]; then
      if [ ! -f ~/.ssh/id_rsa ]; then
        echo '~/.ssh/id_rsa keys does not exist.'
        ssh-keygen -t rsa -b 2048 -f ~/.ssh/id_rsa
      fi
    fi
")

## == ##

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
      vb.memory = SIZE_OF_VMEM
      vb.cpus = NUM_OF_VCPUS
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    end
  end

  # sync directories
  config.vm.synced_folder "./work", "/home/vagrant/work", owner:"vagrant", group:"vagrant"

  # configure SSH
  config.ssh.insert_key = false

  # copy ssh keys
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision :shell, :inline => "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys", run: "always"

  if OS_NAME == "ubuntu" then
    if OS_VERSION == "22.04" then
      # configure network
      config.vm.network :forwarded_port, guest: 22, host: 2022, id: 'ssh'
      
      # enable BTF
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "update-grub"
      config.vm.provision :reload

    elsif OS_VERSION == "20.04" then
      # configure network
      config.vm.network :forwarded_port, guest: 22, host: 2020, id: 'ssh'

    elsif OS_VERSION == "18.04" then
      # configure network
      config.vm.network :forwarded_port, guest: 22, host: 2018, id: 'ssh'

    end

    # do something

  end

  if OS_NAME == "centos" then
    if OS_VERSION == "9" then
      # configure network
      config.vm.network :forwarded_port, guest: 22, host: 2009, id: 'ssh'

      # enable BTF
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=selinux,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "grub2-mkconfig -o /boot/grub2/grub.cfg"
      config.vm.provision :reload

    elsif OS_VERSION == "8" then
      # configure network
      config.vm.network :forwarded_port, guest: 22, host: 2008, id: 'ssh'

    end

    # do something else

  end
end
