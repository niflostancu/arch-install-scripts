#!/bin/bash
# Simple template-based bootloader config generator

CFG ?= /etc/boot-conf-generator/config.mk

# some internal paths
_THIS_MK_FILE = $(lastword $(MAKEFILE_LIST))
BOOT_GEN_SRC := $(patsubst %/,%,$(dir $(_THIS_MK_FILE)))
BOOT_TPL_DIR := $(BOOT_GEN_SRC)/tpl

### some useful macros
# blank (i.e., empty string) variable
blank :=
# variable containing a single new line
define nl
$(blank)
$(blank)
endef
comma = ,
get_dev_uuid = $(shell blkid -s UUID -o value "$(1)")

# load config
include $(CFG)

.ONESHELL:
SHELL = bash
WRITE_ENTRIES_PRE ?= mkdir -p "$(BOOT_DIR)"

.PHONY: generate print
generate:
	$(WRITE_ENTRIES_PRE)
	$(foreach entry,$(BOOT_ENTRIES),$(nl)$(WRITE_ENTRY_CMD)$(nl))

# target for debugging purposes:
print:
	@echo "$$_BOOT_GEN_PRINT_TXT"
_print_all_entries = $(foreach entry,$(BOOT_ENTRIES),\
$(nl)# $(entry) -> $(BOOT_ENTRY_DEST):$(nl)$(BOOT_ENTRY_TPL))
export _BOOT_GEN_PRINT_TXT = $(_print_all_entries)

