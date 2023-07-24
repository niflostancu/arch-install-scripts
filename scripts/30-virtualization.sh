#
# Installs virtualization tools

function do_install_prerequisites() {
    # Docker
    if [[ -n "$INSTALL_DOCKER" ]]; then
        install_pkgs docker docker-buildx docker-compose
    fi

    # Libvirt, Qemu
    if [[ -n "$INSTALL_QEMU" ]]; then
        install_pkgs qemu ebtables qemu-arch-extra qemu-user-static \
            libvirt virt-manager edk2-ovmf
    fi

    if [[ -n "$INSTALL_VM_TOOLS" ]]; then
        install_pkgs vagrant packer debootstrap
    fi
    # X11 / VNC tools
    install_pkgs nxagent xpra xorg-xinit xorg-server-xvfb
}

function do_configure() {
    if [[ -n "$INSTALL_DOCKER" ]]; then
        systemctl enable docker
        # Move docker containers from rootfs
        mkdir -p /etc/systemd/system/docker.service.d/
        # if idem_rsync_conf "systemd/system/docker.service.d/" /etc/systemd/system/docker.service.d/; then
        #     systemctl daemon-reload
        #     systemctl restart docker
        # fi
    fi
    if [[ -n "$INSTALL_VM_TOOLS" ]]; then
        systemctl enable libvirtd
        # Allow wheel to use libvirt freely
        idem_rsync_conf "polkit-1/rules.d/50-libvirt.rules" /etc/polkit-1/rules.d/50-libvirt.rules
        # Allow virbr0 usage from user sessions
        mkdir -p /etc/qemu/
        idem_rsync_conf "qemu/" /etc/qemu
    fi
    true
}

