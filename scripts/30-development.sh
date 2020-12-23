#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # C / C++
    install_pkgs base-devel gdb valgrind strace ltrace peda pwndbg cgdb

    # PHP
    install_pkgs php composer

    # Golang
    install_pkgs go go-tools

	# Java
	install_pkgs maven scala gradle
	install_pkgs jdk-openjdk

	# Python 3
	install_pkgs python python-pip flake8 python-pylint python-pytest python-virtualenv
	install_pkgs python-coverage cython pypy3 python-gobject

	# Python 2
	install_pkgs python2 python2-pip python2-virtualenv
	install_pkgs pypy

	# NodeJS
	install_pkgs nodejs npm yarn

	# Embedded / uC
	install_pkgs minicom cutecom avr-gcc avr-libc avrdude \
		arm-none-eabi-gcc arm-none-eabi-gdb arm-none-eabi-newlib
	install_aur_pkgs openocd
	# Sigrok for logic analyzers
	install_pkgs pulseview
	install_aur_pkgs openocd sigrok-cli sigrok-firmware-fx2lafw-bin 
}

# Copy configuration files to /etc 
function do_configure() {
	# Copy udev rules
	if idem_rsync "$SRC_DIR/etc/udev/" /etc/udev/; then
		udevadm control --reload-rules && sudo udevadm trigger
	fi

	true
}

