#!/bin/bash
#
# Installs disk / filesystem tools

function do_install_prerequisites() {
    install_pkgs gptfdisk dosfstools ntfs-3g smartmontools mtools \
        btrfs-progs nvme-cli exfatprogs
}

function do_configure() {
    # Enable periodic (weekly) SSD TRIM
    systemctl enable fstrim.timer
}

