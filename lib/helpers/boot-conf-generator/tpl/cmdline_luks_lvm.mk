# Template for LUKS+LVM rootfs kernel cmdline
# Supports mkinitcpio & dracut:
# https://wiki.archlinux.org/title/Dm-crypt/System_configuration#Kernel_parameters

# mandatory customization (should be set by user)
ROOT_LUKS_DEV ?= /dev/disk/by-partlabel/LUKS
ROOT_LUKS_UUID ?= $(call get_dev_uuid,$(ROOT_LUKS_DEV))
ROOT_LVM_VOL ?= LinuxVol
ROOT_LVM_PART ?= root
ROOT_LVM_FULL ?= $(ROOT_LVM_VOL)/$(ROOT_LVM_PART)
ROOT_CRYPT_NAME ?= cryptroot
ROOT_LUKS_ALLOW_DISCARD ?= 1
ROOTFS_DEV ?= /dev/$(ROOT_LVM_VOL)/$(ROOT_LVM_PART)
ROOTFS_TYPE ?= ext4
ROOTFS_FLAGS ?= rw,relatime
# available initrd styles: legacy, systemd, dracut
RDINIT_STYLE ?= systemd
# other args:
CMDLINE_CONSOLE ?=
CMDLINE_EXTRA ?= 

# build the kernel cmdline from smaller variables
ENTRY_CMDLINE ?= $(CMDLINE_CONSOLE) $(CMDLINE_$(RDINIT_STYLE)) \
				 $(CMDLINE_ROOTFS) $(CMDLINE_EXTRA)
# mkinitcpio (legacy encrypt hook) cmdline style:
CMDLINE_legacy ?= cryptdevice=$(ROOT_LUKS_DEV):$(ROOT_CRYPT_NAME):$(CMDLINE_CRYPT_OPTS)
CMDLINE_CRYPT_OPTS ?= $(if $(ROOT_LUKS_ALLOW_DISCARD),allow-discards)
# mkinitcpio (systemd encrypt hook) cmdline style:
CMDLINE_SD_DISCARD ?= $(if $(ROOT_LUKS_ALLOW_DISCARD),discard$(comma))
CMDLINE_systemd ?= rd.luks.name=$(ROOT_LUKS_UUID)=$(ROOT_CRYPT_NAME) \
				   rd.luks.options=$(CMDLINE_SD_DISCARD)tries=10
# dracut (systemd) style options:
CMDLINE_dracut ?= $(CMDLINE_DRACUT_OPTS) $(CMDLINE_DRACUT_ROOT)
CMDLINE_DRACUT_OPTS ?= \
		rd.luks.options=$(CMDLINE_SD_DISCARD)tries=10 rd.shell=1 \
		$(if $(ROOT_LUKS_ALLOW_DISCARD),rd.luks.allow-discards)
CMDLINE_DRACUT_ROOT ?= \
		rd.luks.uuid=luks-$(ROOT_LUKS_UUID) \
		rd.lvm.lv=$(ROOT_LVM_FULL)

# root device options
CMDLINE_ROOTFS ?= \
		root=$(ROOTFS_DEV) rootfstype=$(ROOTFS_TYPE) \
		rootflags=$(ROOTFS_FLAGS)

