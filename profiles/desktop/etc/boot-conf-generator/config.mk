# load base templates
include $(BOOT_TPL_DIR)/cmdline_luks_lvm.mk
include $(BOOT_TPL_DIR)/loader_sdboot.mk

BOOT_DIR = /boot/loader/entries

# personalize it:
ROOT_LUKS_DEV = /dev/disk/by-partlabel/LinuxEnc
ROOT_LVM_VOL = LinuxVol
ROOT_LVM_PART = root
ROOTFS_TYPE = xfs
ROOTFS_FLAGS = rw,relatime,x-systemd.device-timeout=0
RDINIT_STYLE = systemd

# extra cmdline:
CMDLINE_CONSOLE = console=tty1
CMDLINE_EXTRA = ip=:::::eth0:dhcp

BOOT_ENTRIES = cachyos cachyos-lts
ENTRY_LABEL[cachyos] = CachyOS (latest)
ENTRY_KERNEL[cachyos] = linux-cachyos
ENTRY_LABEL[cachyos-lts] = CachyOS (lts)
ENTRY_KERNEL[cachyos-lts] = linux-cachyos-lts

