PREFIX ?= /usr/local
_INSTDIR ?= $(DESTDIR)$(PREFIX)
BINDIR ?= $(_INSTDIR)/bin
MANDIR ?= $(_INSTDIR)/share/man
TASK_DONE = echo -e "\n✓ $@ done\n"
SHELL := $(shell which bash)

.PHONY: test

all:
	@echo "Usage:"
	@echo "  make install"
	@echo "  make reinstall"
	@echo "  make uninstall"

help:
	$(MAKE) all
	@$(TASK_DONE)

install:
	install -d -m 0755 $(BINDIR)
	install -m 0755 warrantiak $(BINDIR)/warrantiak
	@$(TASK_DONE)

uninstall:
	rm -f $(BINDIR)/warrantiak
	@$(TASK_DONE)

reinstall:
	@curl -sO https://raw.githubusercontent.com/be-lenka/warrantiak/master/warrantiak
	$(MAKE) install
	@$(TASK_DONE)