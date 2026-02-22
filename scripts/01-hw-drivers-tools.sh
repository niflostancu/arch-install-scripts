#!/bin/bash
# Generic hardware drivers / tools

function do_install_prerequisites() {
    # disk utilities
    install_pkgs gptfdisk parted ntfs-3g smartmontools mtools \
        dosfstools xfsprogs btrfs-progs exfatprogs nvme-cli \
        lvm2 cryptsetup
    # firmware tools
    install_pkgs fwupd fwupd-efi
    # security devices
    install_pkgs rng-tools
}

function do_configure() {
    # Enable periodic (weekly) SSD TRIM
    systemctl enable fstrim.timer
}

