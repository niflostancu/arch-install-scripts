# load base templates
include $(BOOT_TPL_DIR)/cmdline_luks_lvm.mk
include $(BOOT_TPL_DIR)/loader_sdboot.mk

BOOT_DIR = /boot/loader/entries

# personalize it:
ROOT_LUKS_DEV = /dev/disk/by-partlabel/LinuxEnc
ROOT_LVM_VOL = LaptopLinuxVol
ROOT_LVM_PART = root
ROOTFS_TYPE = xfs
RDINIT_STYLE = systemd

# extra cmdline:
CMDLINE_CONSOLE = console=tty1
#CMDLINE_EXTRA = pcie_port_pm=off

BOOT_ENTRIES = cachyos-legion cachyos cachyos-lts
ENTRY_LABEL[cachyos-legion] = CachyOS (legion patches)
ENTRY_KERNEL[cachyos-legion] = linux-cachyos-legion
ENTRY_LABEL[cachyos] = CachyOS (latest)
ENTRY_KERNEL[cachyos] = linux-cachyos
ENTRY_LABEL[cachyos-lts] = CachyOS (lts)
ENTRY_KERNEL[cachyos-lts] = linux-cachyos-lts

