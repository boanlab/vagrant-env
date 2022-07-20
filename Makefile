.PHONY: check
check:
ifeq ($(LOGNAME), vagrant)
	$(error rule must be called from outside the vagrant environment)
endif

.PHONY: up
up: check
	vagrant up; true

.PHONY: status
status: check
	vagrant status; true

.PHONY: reload
reload: check
	vagrant reload; true

.PHONY: ssh
ssh: check
	vagrant ssh; true

.PHONY: halt
halt: check
	vagrant halt; true

.PHONY: destroy
destroy: check
	vagrant destroy; true

.PHONY: clean
clean:
	rm -f *.log
