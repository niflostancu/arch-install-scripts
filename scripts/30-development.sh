#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Shell scripting
    install_pkgs checkbashisms dash

    # C / C++
    install_pkgs gdb valgrind strace ltrace peda pwndbg cgdb cmake bear

    # Tools
    install_pkgs lazygit

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

    # Embedded / uC
    install_pkgs minicom picocom avr-gcc avr-libc avrdude openocd \
        arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib \
        ninja ccache gperf dfu-util

    # Sigrok for logic analyzers
    install_pkgs pulseview sigrok-cli

    # Documentation tools
    install_pkgs ghostwriter
}

# Copy configuration files to /etc 
function do_configure() {
    # Copy udev rules
    if idem_rsync_conf "udev/" /etc/udev/; then
        udevadm control --reload-rules && sudo udevadm trigger
    fi
    true
}

