#!/bin/bash
#
# Installs some base packages

function do_install_prerequisites() {
    # Install basic tools, editors etc.
    install_pkgs vim git sudo unison curl rsync openssh avahi nss-mdns \
        bash-completion wget tree
}

function do_configure() {
    systemctl enable sshd.service
    systemctl enable avahi-daemon

    # Configure pacman (cachyos / multilib)
    if [[ -n "$INSTALL_PACMAN_CONF" ]]; then
        if idem_rsync_conf --opt -- "$INSTALL_PACMAN_CONF" /etc/pacman.conf; then
            pacman --noconfirm -Syu
        fi
    fi
    # Sysctl config
    if idem_rsync_conf --all -- "sysctl.d/" /etc/sysctl.d/; then
        touch /etc/sysctl.conf
        sysctl -p
    fi
    true
}

