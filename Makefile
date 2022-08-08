include .env

.PHONY: vagrant-check
vagrant-check:
ifeq ($(LOGNAME), vagrant)
	$(error rule must be called from outside the vagrant environment)
endif

.PHONY: vagrant-up
vagrant-up: vagrant-check
	@echo "OS=${OS}" > .env
	@echo "VERSION=${VERSION}" >> .env
	@echo "K8S=${K8S}" >> .env
	@echo "RUNTIME=${RUNTIME}" >> .env
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant up; true

.PHONY: vagrant-status
vagrant-status: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant status; true

.PHONY: vagrant-reload
vagrant-reload: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant reload; true

.PHONY: vagrant-ssh
vagrant-ssh: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant ssh; true

.PHONY: vagrant-halt
vagrant-halt: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant halt; true

.PHONY: vagrant-destroy
vagrant-destroy: vagrant-check
	@echo > .env
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} K8S=${K8S} RUNTIME=${RUNTIME} vagrant destroy; true

.PHONY: clean
clean:
	rm -f *.log
