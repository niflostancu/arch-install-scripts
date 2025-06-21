#
# Installs virtualization tools

function do_install_prerequisites() {
    # Docker
    if [[ -n "$INSTALL_DOCKER" ]]; then
        install_pkgs docker docker-buildx docker-compose
    fi

    # Libvirt, Qemu
    if [[ -n "$INSTALL_QEMU" ]]; then
        install_pkgs qemu-base qemu-desktop qemu-user-static qemu-user-static-binfmt \
            qemu-system-arm qemu-system-aarch64 \
            libvirt virt-manager edk2-ovmf
        # install_pkgs qemu-emulators-full
    fi

    if [[ -n "$INSTALL_VM_TOOLS" ]]; then
        install_pkgs packer debootstrap
    fi
    # X11 / VNC tools
    install_pkgs xpra xorg-xinit xorg-server-xvfb
}

function do_configure() {
    if [[ -n "$INSTALL_DOCKER" ]]; then
        systemctl enable docker
        # Move docker containers from rootfs
        mkdir -p /etc/docker
        if idem_rsync_conf "docker/" "/etc/docker/"; then
            systemctl restart docker
        fi
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

