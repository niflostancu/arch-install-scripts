#!/bin/bash
#
# Installs some required drivers / microcode updates

if [[ -z "$INSTALL_DRIVERS" ]]; then return; fi

function do_install_prerequisites() {
    install_pkgs linux-headers
    install_pkgs intel-ucode
}

