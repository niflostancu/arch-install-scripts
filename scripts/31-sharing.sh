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
    # systemctl enable nfs-server
    systemctl enable smb.service nmb.service
    
    # Samba config
    mkdir -p /etc/samba
    groupadd -rf sambashare
    if [[ ! -d /var/lib/samba/usershares ]]; then
        mkdir -p /var/lib/samba/usershares
        chown root:sambashare /var/lib/samba/usershares
        # make it sticky
        chmod 1770 /var/lib/samba/usershares
    fi

    if idem_rsync_conf "samba/" /etc/samba/; then
        systemctl restart smb nmb
    fi

}

