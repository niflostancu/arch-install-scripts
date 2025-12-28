#!/bin/bash
#
# Gaming tools

if [[ -z "$INSTALL_GAMING" ]]; then return; fi

function do_install_prerequisites() {
    # Libs
    install_pkgs lib32-pipewire
    # Gaming tools
    install_pkgs steam
    install_pkgs wine winetricks lutris
    install_pkgs --aur proton-cachyos

    # Hybrid graphics
    install_pkgs vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools

    install_pkgs openbox
}

function do_configure() {
    true
}

