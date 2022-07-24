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
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant up; true

.PHONY: vagrant-status
vagrant-status: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant status; true

.PHONY: vagrant-reload
vagrant-reload: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant reload; true

.PHONY: vagrant-ssh
vagrant-ssh: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant ssh; true

.PHONY: vagrant-halt
vagrant-halt: vagrant-check
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant halt; true

.PHONY: vagrant-destroy
vagrant-destroy: vagrant-check
	@echo > .env
	PREFIX=$$(basename $(PWD)) OS=${OS} VERSION=${VERSION} vagrant destroy; true

.PHONY: clean
clean:
	rm -f *.log
