#!/bin/bash
# Kernel/boot-related packages & configs

declare -a -g ADD_PLATFORM_PACKAGES
INSTALL_KERNEL_VARIANT=${INSTALL_KERNEL_VARIANT:-linux}


function do_install_prerequisites() {
    install_pkgs "$INSTALL_KERNEL_VARIANT-headers" "${ADD_PLATFORM_PACKAGES[@]}"

    if [[ -n "$INSTALL_MICROCODE" ]]; then
        install_pkgs "$INSTALL_X86_DRIVERS"-ucode
    fi
}

