#!/bin/bash
#
# Installs some required drivers / microcode updates

function do_install_prerequisites() {
    install_pkgs intel-ucode
}

