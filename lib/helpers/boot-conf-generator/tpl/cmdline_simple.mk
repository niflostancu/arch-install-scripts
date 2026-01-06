# Template for a simple/basic rootfs kernel cmdline

# mandatory customization (should be set by user)
ROOTFS_DEV ?= /dev/disk/by-partlabel/LinuxRoot
ROOTFS_TYPE ?= ext4
ROOTFS_FLAGS ?= rw,relatime
# other args:
CMDLINE_CONSOLE ?=
CMDLINE_EXTRA ?= 

# build the kernel cmdline from smaller variables
ENTRY_CMDLINE ?= $(CMDLINE_CONSOLE) $(CMDLINE_ROOTFS) $(CMDLINE_EXTRA)

# root device options
CMDLINE_ROOTFS ?= \
		root=$(ROOTFS_DEV) rootfstype=$(ROOTFS_TYPE) \
		rootflags=$(ROOTFS_FLAGS)

