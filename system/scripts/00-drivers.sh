#!/bin/bash
#
# Installs some required drivers / microcode updates

function do_install_prerequisites() {
    # Install basic tools, editors etc.
    install_pkgs intel-ucode
}

