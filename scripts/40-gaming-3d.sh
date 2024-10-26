#!/bin/bash
#
# Gaming tools

if [[ -z "$INSTALL_GAMING" ]]; then return; fi

function do_install_prerequisites() {
    # Libs
    install_pkgs lib32-pipewire
    # Gaming tools
    install_pkgs steam steam-native-runtime
    install_pkgs wine winetricks lutris

    # Hybrid graphics
    install_pkgs vulkan-icd-loader lib32-vulkan-icd-loader vulkan-tools

    if [[ "$INSTALL_GAMING_HYBRID" == "nvidia" ]]; then 
        # bbswitch not required anymore!
        # install_pkgs bbswitch-dkms
        install_pkgs nvidia-prime
    fi
    install_pkgs openbox
}

function do_configure() {
    true
}

