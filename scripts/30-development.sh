#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Shell scripting
    install_pkgs checkbashisms dash

    # C / C++
    install_pkgs gdb cmake ninja ccache clang valgrind strace ltrace cgdb bear

    # Versioning Tools
    # LibGit2 required by some nvim plugins (fugit2)
    install_pkgs git lazygit github-cli libgit2

    # PHP
    install_pkgs php composer

    # Golang
    install_pkgs go go-tools

    # Java
    install_pkgs maven scala gradle
    install_pkgs jdk-openjdk

    # Python (3 only)
    install_pkgs python python-pip flake8 python-pylint python-pytest python-virtualenv
    install_pkgs python-pipx python-coverage cython pypy3 python-gobject pyenv

    # NodeJS
    install_pkgs nodejs npm yarn

    # Compilation deps (arch devtools, Linux kernels etc.)
    install_pkgs devtools xmlto kmod inetutils bc libelf cpio perl tar xz

    # Embedded / uC
    install_pkgs minicom picocom avr-gcc avr-libc avrdude openocd \
        arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib \
        gperf dfu-util platformio-core platformio-core-udev

    # Sigrok + Pulseview for logic analyzers
    install_pkgs pulseview sigrok-cli
}

# Copy configuration files to /etc 
function do_configure() {
    # Copy udev rules
    if idem_rsync_conf --all "udev/" /etc/udev/; then
        udevadm control --reload-rules && sudo udevadm trigger
    fi
    true
}

