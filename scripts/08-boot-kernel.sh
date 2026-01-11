#!/bin/bash
# Kernel/boot-related packages & configs

declare -a -g ADD_PLATFORM_PACKAGES
INSTALL_KERNEL_VARIANT=${INSTALL_KERNEL_VARIANT:-linux}

function do_install_prerequisites() {
    pacman -Qi systemd-boot-manager &>/dev/null && pacman -R systemd-boot-manager || true
    install_pkgs "$INSTALL_KERNEL_VARIANT-headers" "${ADD_PLATFORM_PACKAGES[@]}"

    # profile-specific firmware / microcode
    if [[ -n "$INSTALL_FIRMWARE" ]]; then
        install_pkgs "${INSTALL_FIRMWARE[@]}"
    fi
}

function do_configure() {
    if idem_rsync_conf --all "boot-conf-generator/" "/etc/boot-conf-generator/"; then
        "$SRC_DIR/lib/helpers/boot-conf-generator/run.sh"
    fi
}
