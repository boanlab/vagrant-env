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
make vagrant-up OS=ubuntu VERSION={18.04,20.04,21.10,22.04}
make vagrant-up OS=centos VERSION={8,9}
```

- Default values

```
if OS=centos then
  VERSION=8 by default

else if OS=ubuntu then
  VERSION=18.04 by default

else
  OS=ubuntu VERSION=18.04 by default
```
