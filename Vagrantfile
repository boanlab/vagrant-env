Vagrant.require_version ">= 2.0.0"

ENV_NAME = ENV['PREFIX'] || "vagrant-env"

OS_NAME    = ENV['OS'] || "ubuntu"
OS_VERSION = ENV['VERSION'] || "focal"
K8S        = ENV['K8S'] || "none"
RUNTIME    = ENV['RUNTIME'] || "none"

# disable the following lines if not linux
# OS_NAME = "ubuntu"
# OS_VERSION = "jammy"
# K8S = "none"
# RUNTIME = "none"

if OS_NAME == "" then
  OS_NAME = "ubuntu"
elsif OS_NAME != "ubuntu" && OS_NAME != "centos" then
  puts "Unkonwn OS_NAME: ENV['OS'] = { 'ubuntu' | 'centos' }"
  abort
end

if OS_NAME == "ubuntu" && OS_VERSION == "" then
  OS_VERSION = "jammy"
elsif OS_NAME == "ubuntu" && (OS_VERSION != "bionic" && OS_VERSION != "focal" && OS_VERSION != "jammy") then
    puts "Unknown OS_VERSION: ENV['VERSION'] = { 'binoic' | 'focal' | 'jammy' }"
    abort
end

if OS_NAME == "centos" && OS_VERSION == "" then
  OS_VERSION = "9"
elsif OS_NAME == "centos" && (OS_VERSION != "8" && OS_VERSION != "9") then
  puts "Unknown OS_VERSION: ENV['VERSION'] = { '8' | '9' }"
  abort
end

if K8S == "" then
  K8S = "none"
elsif K8S != "k3s" && K8S != "kubeadm" && K8S != "none" then
  puts "Unknown K8S: ENV['K8S'] = { 'k3s' | 'kubeadm' | 'none' }"
  abort
end

if RUNTIME == "" then
  RUNTIME = "none"
elsif RUNTIME != "docker" && RUNTIME != "crio" && RUNTIME != "containerd" && RUNTIME != "none" then
  puts "Unknown RUNTIME: ENV['RUNTIME'] = { 'docker' | 'crio' | 'containerd' | 'none' }"
  abort
end

puts "OS_NAME: " + OS_NAME + ", OS_VERSION: " + OS_VERSION + ", K8S: " + K8S + ", RUNTIME: " + RUNTIME

## == ##

if OS_NAME == "centos" then
  if OS_VERSION == "9" then
    VM_IMG = "generic/centos9s"
    VM_NAME = ENV_NAME + "-centos9s"
  elsif OS_VERSION == "8" then
    VM_IMG = "generic/centos8s"
    VM_NAME = ENV_NAME + "-centos8s"
  end
elsif OS_NAME == "ubuntu" then
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

## == ##

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
      vb.memory = 4096
      vb.cpus = 4
      vb.customize ['modifyvm', :id, '--nested-hw-virt', 'on']
    end
  end

  # sync directories
  config.vm.synced_folder "./data", "/home/vagrant/data", owner:"vagrant", group:"vagrant"
  config.vm.synced_folder "./setup", "/home/vagrant/setup", owner:"vagrant", group:"vagrant"

  # copy ssh keys
  config.vm.provision "file", source: "~/.ssh/id_rsa.pub", destination: "/home/vagrant/.ssh/id_rsa.pub"
  config.vm.provision :shell, :inline => "cat /home/vagrant/.ssh/id_rsa.pub >> /home/vagrant/.ssh/authorized_keys", run: "always"

  if OS_NAME == "centos" then
    if OS_VERSION == "9" then
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=selinux,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "grub-mkconfig -o /boot/grub/grub.cfg"
      config.vm.provision :reload
    end

    if RUNTIME == "docker" then
      # install docker
      config.vm.provision :shell, :inline => "/home/vagrant/setup/centos/install_docker.sh"
    elsif RUNTIME == "crio" then
      # install cri-o
      config.vm.provision :shell, :inline => "/home/vagrant/setup/centos/install_crio.sh"
    elsif RUNTIME == "containerd" then
      # install containerd
      config.vm.provision :shell, :inline => "/home/vagrant/setup/centos/install_containerd.sh"
    end

    if K8S == "k3s" then
      # install k3s
      config.vm.provision :shell, :inline => "/home/vagrant/setup/k3s/install_k3s.sh"
    elsif K8S == "kubeadm" then
      # install kubernetes
      config.vm.provision :shell, :inline => "RUNTIME=" + RUNTIME + " /home/vagrant/setup/centos/install_kubernetes.sh"

      # initialize kubernetes
      config.vm.provision :shell, privileged: false, :inline => "CNI=flannel MASTER=true /home/vagrant/setup/centos/initialize_kubernetes.sh"
    end

    # enable selinux
    config.vm.provision :shell, :inline => "/home/vagrant/setup/centos/enable_selinux.sh"

    # do something else

  else # ubuntu
    if OS_VERSION == "jammy" then
      config.vm.provision :shell, :inline => "sed -i 's/GRUB_CMDLINE_LINUX=\"\"/GRUB_CMDLINE_LINUX=\"lsm=apparmor,bpf\"/g' /etc/default/grub"
      config.vm.provision :shell, :inline => "update-grub"
      config.vm.provision :reload
    end

    if RUNTIME == "docker" then
      # install docker
      config.vm.provision :shell, :inline => "/home/vagrant/setup/ubuntu/install_docker.sh"
    elsif RUNTIME == "crio" then
      # install cri-o
      config.vm.provision :shell, :inline => "/home/vagrant/setup/ubuntu/install_crio.sh"
    elsif RUNTIME == "containerd" then
      # install containerd
      config.vm.provision :shell, :inline => "/home/vagrant/setup/ubuntu/install_containerd.sh"
    end

    if K8S == "k3s" then
      # install k3s
      config.vm.provision :shell, :inline => "/home/vagrant/setup/k3s/install_k3s.sh"
    elsif K8S == "kubeadm" then
      # install Kubernetes
      config.vm.provision :shell, :inline => "RUNTIME=" + RUNTIME + " /home/vagrant/setup/ubuntu/install_kubernetes.sh"

      # initialize kubernetes
      config.vm.provision :shell, privileged: false, :inline => "CNI=flannel MASTER=true /home/vagrant/setup/ubuntu/initialize_kubernetes.sh"
    end

    # do something

  end
end
