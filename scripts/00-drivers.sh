#!/bin/bash
#
# Installs some required drivers / microcode updates

function do_install_prerequisites() {
    install_pkgs linux-headers

    if [[ -n "$INSTALL_X86_DRIVERS" ]]; then
        install_pkgs intel-ucode
    fi
}

