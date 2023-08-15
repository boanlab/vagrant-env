Vagrant.require_version ">= 2.0.0"

ENV_NAME = ENV['PREFIX'] || "vagrant-env"

OS_NAME    = ENV['OS'] || "ubuntu"
OS_VERSION = ENV['VERSION'] || "jammy"
NUM_OF_VCPUS = 4
SIZE_OF_VMEM = 4096

# disable the following lines if not linux
# OS_NAME = "ubuntu"
# OS_VERSION = "jammy"
# K8S = "none"
# RUNTIME = "none"

# check if the given os is supported
if OS_NAME == "" then
  OS_NAME = "ubuntu"
elsif OS_NAME != "ubuntu" && OS_NAME != "centos" then
  puts "Unkonwn OS_NAME: ENV['OS'] = { 'ubuntu' | 'centos' }"
  abort
end

# check if the given version is supported
if OS_NAME == "ubuntu" && OS_VERSION == "" then
  OS_VERSION = "jammy"
elsif OS_NAME == "ubuntu" && (OS_VERSION != "bionic" && OS_VERSION != "focal" && OS_VERSION != "jammy") then
    puts "Unknown OS_VERSION: ENV['VERSION'] = { 'binoic' | 'focal' | 'jammy' }"
    abort
end

# check if the given version is supported
if OS_NAME == "centos" && OS_VERSION == "" then
  OS_VERSION = "9"
elsif OS_NAME == "centos" && (OS_VERSION != "8" && OS_VERSION != "9") then
  puts "Unknown OS_VERSION: ENV['VERSION'] = { '8' | '9' }"
  abort
end

puts "OS_NAME: " + OS_NAME + ", OS_VERSION: " + OS_VERSION

## == ##

# set the specific Ubuntu image and VM name
if OS_NAME == "ubuntu" then
  if OS_VERSION == "jammy" then
    VM_IMG = "generic/ubuntu2204" # 5.15
    VM_NAME = ENV_NAME + "-jammy"
  elsif OS_VERSION == "focal" then
    VM_IMG = "generic/ubuntu2004" # 5.4
    VM_NAME = ENV_NAME + "-focal"
  elsif OS_VERSION == "bionic" then
    VM_IMG = "generic/ubuntu1804" # 4.15
    VM_NAME = ENV_NAME + "-bionic"
  end
end

# set the specific CentOS image and VM name
if OS_NAME == "centos" then
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
        ssh-keygen -t rsa -f ~/.ssh/id_rsa
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
  config.vm.synced_folder "./home_dir", "/home/vagrant", owner:"vagrant", group:"vagrant"

  # copy ssh keys
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision :shell, :inline => "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys", run: "always"

  if OS_NAME == "ubuntu" then
    if OS_VERSION == "jammy" then
      # enable BTF
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "update-grub"
      config.vm.provision :reload
    end

    # do something

  end

  if OS_NAME == "centos" then
    if OS_VERSION == "9" then
      # enable BTF
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=selinux,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "grub-mkconfig -o /boot/grub/grub.cfg"
      config.vm.provision :reload
    end

    # do something else

  end
end
