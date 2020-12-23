#!/bin/bash
#
# Gaming tools

if [[ -z "$INSTALL_GAMING" ]]; then return; fi

function do_install_prerequisites() {
    # Drivers
    install_pkgs nvidia-dkms lib32-nvidia-utils
    # Gaming tools
    install_pkgs steam steam-native-runtime
    install_aur_pkgs wine winetricks lutris

    # Hybrid graphics
    install_pkgs bbswitch-dkms vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools
    install_aur_pkgs nvidia-xrun
    install_pkgs openbox
}

function do_configure() {
    true
}

