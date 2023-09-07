#!/bin/bash
# Installs & configures the font system

function do_install_prerequisites() {
    install_pkgs gnu-free-fonts noto-fonts ttf-ubuntu-font-family ttf-dejavu \
        ttf-liberation ttf-bitstream-vera ttf-sourcecodepro-nerd
    install_pkgs --aur ttf-ms-win11-auto
}

