#!/bin/bash
#
# Installs disk / filesystem tools

function do_install_prerequisites() {
    install_pkgs gptfdisk dosfstools ntfs-3g smartmontools mtools \
        btrfs-progs
}

