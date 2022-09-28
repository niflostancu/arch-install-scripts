#!/bin/bash
#
# Installs some required drivers / microcode updates

declare -a -g ADD_PLATFORM_PACKAGES

function do_install_prerequisites() {
    install_pkgs linux-headers "${ADD_PLATFORM_PACKAGES[@]}"

    if [[ -n "$INSTALL_X86_DRIVERS" ]]; then
        install_pkgs intel-ucode
    fi
}

