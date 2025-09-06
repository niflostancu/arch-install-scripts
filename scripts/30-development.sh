#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Shell scripting
    install_pkgs checkbashisms dash
    # Arch Wiki Docs
    install_pkgs arch-wiki-lite

    # C / C++
    install_pkgs gdb cmake ninja ccache clang valgrind strace ltrace cgdb bear \
        perf

    # Versioning Tools
    # LibGit2 required by some nvim plugins (fugit2)
    install_pkgs git lazygit github-cli libgit2

    # PHP
    install_pkgs php composer

    # Golang
    install_pkgs go go-tools

    # Java
    install_pkgs maven gradle
    install_pkgs jdk-openjdk

    # Python (3 only)
    install_pkgs python python-pip python-pylint python-pytest python-virtualenv
    install_pkgs python-pipx python-coverage cython pypy3 python-gobject pyenv

    # NodeJS
    install_pkgs nodejs npm yarn

    # Compilation deps (arch devtools, Linux kernels etc.)
    install_pkgs devtools xmlto kmod inetutils bc libelf cpio perl tar xz \
        repo

    # Embedded / uC
    install_pkgs minicom picocom avr-gcc avr-libc avrdude \
        arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib \
        gperf dfu-util platformio-core platformio-core-udev

    # install openocd from git (since latest is old as fsck)
    install_pkgs --aur openocd-git
    # ofc we need to patch jimtcl first...
    if ! check_pkg_installed jimtcl || [[ -n "$FORCE_REINSTALL" ]]; then
        build_custom_pkg -i --noconfirm jimtcl
    fi
    if ! check_pkg_installed openocd-git || [[ -n "$FORCE_REINSTALL" ]]; then
        build_custom_pkg -i --noconfirm openocd-git
    fi

    # Sigrok + Pulseview for logic analyzers
    #install_pkgs pulseview sigrok-cli
    install_pkgs --aur libsigrokdecode-git libsigrok-git sigrok-cli-git
    if ! check_pkg_installed pulseview-git || [[ -n "$FORCE_REINSTALL" ]]; then
        build_custom_pkg -i --noconfirm pulseview-git
    fi
}

# Copy configuration files to /etc 
function do_configure() {
    # Copy udev rules
    if idem_rsync_conf --all "udev/" /etc/udev/; then
        udevadm control --reload-rules && sudo udevadm trigger
    fi
    true
}

