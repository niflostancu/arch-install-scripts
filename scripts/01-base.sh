#!/bin/bash
#
# Installs some base packages

function do_install_prerequisites() {
    # Install basic tools, editors etc.
    install_pkgs vim git sudo unison curl rsync openssh avahi nss-mdns \
        bash-completion wget tree
}

function do_configure() {
    systemctl enable sshd.socket
    systemctl enable avahi-daemon

    # Configure pacman (for multilib)
    if [[ "$SYSTEM_ARCH" == "amd64" ]]; then
        if idem_rsync "$SRC_DIR/etc/pacman.conf" /etc/pacman.conf; then
            pacman --noconfirm -Syu
        fi
    fi

    # Sysctl config
    if idem_rsync "$SRC_DIR/etc/sysctl.d/" "/etc/sysctl.d/"; then
        touch /etc/sysctl.conf
        sysctl -p
    fi

    true
}

