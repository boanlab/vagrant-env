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
make {...} OS=ubuntu VERSION={18.04,20.04,21.10,22.04}
make {...} OS=centos VERSION={8,9}
```

- Default values

```
if OS=centos then
  VERSION=8 by default

if OS=ubuntu then
  VERSION=18.04 by default

Otherwise
  OS=ubuntu VERSION=18.04 by default
```
