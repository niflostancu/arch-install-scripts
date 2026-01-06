# systemd-boot loader entries generator

# sdboot paths
BOOT_DIR ?= /boot/loader/entries
BOOT_ENTRY_DEST ?= $(BOOT_DIR)/$(entry).conf
# override to customize entries:
BOOT_ENTRIES ?= main lts

ENTRY_LABEL[main] ?= Linux
ENTRY_LABEL[lts] ?= Linux (LTS)
ENTRY_KERNEL[main] ?= linux
ENTRY_KERNEL[lts] ?= linux-lts

# boot entry template
define BOOT_ENTRY_TPL ?=
title $(ENTRY_LABEL)
linux $(ENTRY_KERNEL_PATH)
initrd $(ENTRY_INITRD_PATH)
options $(ENTRY_CMDLINE)

endef
# entry args:
ENTRY_LABEL ?= Linux $(ENTRY_LABEL[$(entry)])
ENTRY_KERNEL_PATH = /vmlinuz-$(ENTRY_KERNEL[$(entry)])
ENTRY_INITRD_PATH = /initramfs-$(ENTRY_KERNEL[$(entry)]).img

# command used to write entry files
define WRITE_ENTRY_CMD ?=
cat << 'END_OF_BOOT_ENTRY' > "$(BOOT_ENTRY_DEST)"
$(BOOT_ENTRY_TPL)
END_OF_BOOT_ENTRY
endef

