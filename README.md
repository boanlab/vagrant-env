# vagrant-env

- Commands

```
make up      = vagrant up
make status  = vagrant status
make reload  = vagrant reload
make ssh     = vagrant ssh
make halt    = vagrant halt
make destroy = vagrant destroy
make clean   = rm -f *.log
```

- OS and Version

```
make up OS=ubuntu VERSION={18.04,20.04,21.10,22.04}
make up OS=centos VERSION={8,9}
```

- Default values

```
If OS=centos, VERSION=8 by default
Otherwise, OS=ubuntu VERSION=18.04 by default
```
