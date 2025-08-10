#!/bin/bash
# Installs & configures the font system

function do_install_prerequisites() {
    install_pkgs gnu-free-fonts noto-fonts ttf-ubuntu-font-family ttf-dejavu \
        ttf-liberation ttf-bitstream-vera ttf-sourcecodepro-nerd \
        ttf-cascadia-code-nerd ttf-cascadia-mono-nerd \
        ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols ttf-nerd-fonts-symbols-mono
    install_pkgs --aur ttf-ms-win11-auto
}

