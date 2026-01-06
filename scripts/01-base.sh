#!/bin/bash
#
# Installs some base packages

function do_install_prerequisites() {
    # Install basic tools, editors etc.
    pacman -Sy || true
    install_pkgs vim git sudo unison curl rsync openssh avahi nss-mdns \
        bash-completion wget tree arch-install-scripts make
}

function do_configure() {
    # ssh config
    if idem_rsync_conf --all -- "ssh/" /etc/ssh/; then
        systemctl restart sshd
    fi
    systemctl enable --now sshd.service

    systemctl enable --now avahi-daemon

    # Sysctl config
    if idem_rsync_conf --all -- "sysctl.d/" /etc/sysctl.d/; then
        touch /etc/sysctl.conf
        sysctl -p
    fi
    # Systemd config
    if idem_rsync_conf --all -- "systemd/" /etc/systemd/; then
        systemctl daemon-reload
    fi
    true
}

