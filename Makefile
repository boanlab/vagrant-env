.PHONY: vagrant-check
vagrant-check:
ifeq ($(LOGNAME), vagrant)
	$(error rule must be called from outside the vagrant environment)
endif

.PHONY: vagrant-up
vagrant-up: vagrant-check
	vagrant up; true

.PHONY: vagrant-status
vagrant-status: vagrant-check
	vagrant status; true

.PHONY: vagrant-reload
vagrant-reload: vagrant-check
	vagrant reload; true

.PHONY: vagrant-ssh
vagrant-ssh: vagrant-check
	vagrant ssh; true

.PHONY: vagrant-halt
vagrant-halt: vagrant-check
	vagrant halt; true

.PHONY: vagrant-destroy
vagrant-destroy: vagrant-check
	vagrant destroy; true

.PHONY: clean
clean:
	rm -f *.log
