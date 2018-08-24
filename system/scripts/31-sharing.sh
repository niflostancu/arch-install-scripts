#!/bin/bash
#
# Sharing tools: Samba, NFS

function do_install_prerequisites() {
    # NFS
    install_pkgs nfs-utils

    # Samba
    install_pkgs samba
}

function do_configure() {
    systemctl enable nfs-server
    # systemctl enable samba

    true
}

