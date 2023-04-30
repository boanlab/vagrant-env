# vagrant-env

- Virtualbox and Vagrant

	- If your OS is Ubuntu, you can use 'setup/install-vagrant-with-vbox.sh' to install them.  
	- If not, you need to install Virtualbox and Vagrant by yourself.  

- Commands (Linux only)

```
make vagrant-up      = vagrant up
make vagrant-status  = vagrant status
make vagrant-reload  = vagrant reload
make vagrant-ssh     = vagrant ssh
make vagrant-halt    = vagrant halt
make vagrant-destroy = vagrant destroy
make clean           = rm -f *.log
```

- OS and Version (Linux only)

```
make vagrant-up OS=ubuntu VERSION={bionic,focal,jammy}
make vagrant-up OS=centos VERSION={8,9}
```

	- If you're on Windows OS, you need to modify Vagrantfile to choose specific options.  

- Reference

```
Ubuntu 18.04 = bionic
Ubuntu 20.04 = focal
Ubuntu 22.04 = jammy
```

```
if OS=centos then
  VERSION=9 by default

else if OS=ubuntu then
  VERSION=jammy by default

else
  OS=ubuntu VERSION=jammy by default
```
