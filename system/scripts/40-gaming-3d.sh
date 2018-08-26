#!/bin/bash
#
# Sharing tools: Samba, NFS

function do_install_prerequisites() {
    # Drivers
    install_pkgs nvidia-dkms
    # Gaming tools
    install_pkgs steam steam-native-runtime
    install_yaourt_pkgs wine winetricks lutris

    # Hybrid graphics
    install_pkgs bumblebee bbswitch-dkms vulkan-icd-loader lib32-vulkan-icd-loader
    install_yaourt_pkgs nvidia-xrun
    install_pkgs openbox
}

function do_configure() {
    true
}

