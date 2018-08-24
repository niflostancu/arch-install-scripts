#!/bin/bash
#
# Installs virtualization tools

function do_install_prerequisites() {
    # Docker
    install_pkgs docker docker-compose debootstrap

    # Libvirt, Qemu
    install_pkgs qemu qemu-arch-extra libvirt virt-manager 
    install_yaourt_pkgs qemu-user-static binfmt-qemu-static

    # Vagrant
    install_pkgs vagrant packer-io
}

function do_configure() {
    systemctl enable docker
    systemctl enable libvirtd
    gpasswd -a $SUDO_USER docker
    gpasswd -a $SUDO_USER wheel
    gpasswd -a $SUDO_USER users

    # Allow wheel to use libvirt freely
    idem_rsync "$SRC_DIR/etc/polkit-1/rules.d/50-libvirt.rules" /etc/polkit-1/rules.d/50-libvirt.rules

    # Move docker containers from rootfs
    mkdir -p /etc/systemd/system/docker.service.d/
    if idem_rsync "$SRC_DIR/etc/systemd/system/docker.service.d/" /etc/systemd/system/docker.service.d/; then
        systemctl daemon-reload
        systemctl restart docker
    fi

    # Allow virbr0 usage from user sessions
    mkdir -p /etc/qemu/
    idem_rsync "$SRC_DIR/etc/qemu/" /etc/qemu

    true
}

