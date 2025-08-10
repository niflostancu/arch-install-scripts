#!/bin/bash
#
# Installs disk / filesystem tools

function do_install_prerequisites() {
    install_pkgs gptfdisk parted ntfs-3g smartmontools mtools \
        dosfstools xfsprogs btrfs-progs exfatprogs nvme-cli \
        lvm2 cryptsetup
}

function do_configure() {
    # Enable periodic (weekly) SSD TRIM
    systemctl enable fstrim.timer
}

