# vagrant-env

- Prerequisite: Vagrant over Virtualbox (or KVM/QEMU)

	- Find the scripts for your environment in the 'setup' directory.
	- Otherwise, you need to install Virtualbox and Vagrant by yourself.

- How to use this?

	```
	make vagrant-up      = vagrant up
	make vagrant-status  = vagrant status
	make vagrant-reload  = vagrant reload
	make vagrant-ssh     = vagrant ssh
	make vagrant-halt    = vagrant halt
	make vagrant-destroy = vagrant destroy
	make clean           = rm -f *.log
	```

- How to specify the Linux distribution and version?

	```
	make vagrant-up OS=ubuntu VERSION={ 18.04 | 20.04 | 22.04 }
	make vagrant-up OS=centos VERSION={ 8 | 9 }
	```

- Default Configuration

	- If OS='centos', then VERSION='9' by default
	- If OS='ubuntu', then VERSION='22.04' by default
	- If nothing is given, then OS='ubuntu' and VERSION='22.04' by default

