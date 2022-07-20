# vagrant-env

- Commands

```
make vagrant-up      = vagrant up
make vagrant-status  = vagrant status
make vagrant-reload  = vagrant reload
make vagrant-ssh     = vagrant ssh
make vagrant-halt    = vagrant halt
make vagrant-destroy = vagrant destroy
make clean           = rm -f *.log
```

- OS and Version

```
make vagrant-up OS=ubuntu VERSION={bionic,focal,impish,jammy}
make vagrant-up OS=centos VERSION={8,9}
make vagrant-up OS=rhel   VERSION={8,9}
```

```
Ubuntu 18.04 = bionic
Ubuntu 20.04 = focal
Ubuntu 21.10 = impish
Ubuntu 22.04 = jammy
```

- Default values

```
if OS=centos then
  VERSION=8 by default

else if OS=rhel then
  VERSION=8 by default

else if OS=ubuntu then
  VERSION=bionic by default

else
  OS=ubuntu VERSION=bionic by default
```
