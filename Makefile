PREFIX ?= /usr/local
_INSTDIR ?= $(DESTDIR)$(PREFIX)
BINDIR ?= $(_INSTDIR)/bin
MANDIR ?= $(_INSTDIR)/share/man
SHAREDIR ?= $(_INSTDIR)/share/warrantiak
LIBDIR ?= $(SHAREDIR)/lib
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
	install -d -m 0755 $(LIBDIR)
	install -m 0644 lib/*.sh $(LIBDIR)/
	@$(TASK_DONE)

uninstall:
	rm -f $(BINDIR)/warrantiak
	rm -rf $(SHAREDIR)
	@$(TASK_DONE)

reinstall:
	$(MAKE) uninstall
	$(MAKE) install
	@$(TASK_DONE)