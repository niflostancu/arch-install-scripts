#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Shell scripting
    install_pkgs checkbashisms dash

    # C / C++
    install_pkgs gdb valgrind strace ltrace peda cgdb cmake bear

    # Versioning Tools
    install_pkgs git lazygit github-cli

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
        ninja ccache gperf dfu-util clang

    # Sigrok for logic analyzers (using custom %-git for now)
    # install_pkgs pulseview sigrok-cli

    # Documentation / tools
    install_pkgs man-pages man-db ghostwriter
}

# Copy configuration files to /etc 
function do_configure() {
    # Copy udev rules
    if idem_rsync_conf --all "udev/" /etc/udev/; then
        udevadm control --reload-rules && sudo udevadm trigger
    fi
    true
}

