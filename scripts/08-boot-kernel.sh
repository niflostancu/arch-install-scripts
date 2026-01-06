#!/bin/bash
# Kernel/boot-related packages & configs

declare -a -g ADD_PLATFORM_PACKAGES
INSTALL_KERNEL_VARIANT=${INSTALL_KERNEL_VARIANT:-linux}

function do_install_prerequisites() {
    pacman -Qi systemd-boot-manager &>/dev/null && pacman -R systemd-boot-manager || true
    install_pkgs "$INSTALL_KERNEL_VARIANT-headers" "${ADD_PLATFORM_PACKAGES[@]}"

    if [[ -n "$INSTALL_MICROCODE" ]]; then
        install_pkgs "$INSTALL_MICROCODE"-ucode
    fi
}

function do_configure() {
    if idem_rsync_conf --all "boot-conf-generator/" "/etc/boot-conf-generator/"; then
        "$SRC_DIR/lib/helpers/boot-conf-generator/run.sh"
    fi
}
