#!/bin/bash
#
# Installs & configures the font system

function do_install_prerequisites() {
    install_pkgs ttf-ubuntu-font-family ttf-dejavu \
        adobe-source-code-pro-fonts
}

