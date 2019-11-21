#!/bin/bash
#
# Installs Bluetooth & Mobile tools

function do_install_prerequisites() {
    # Bluetooth
    install_pkgs pulseaudio-bluetooth bluez bluez-libs bluez-utils bluez-firmware
    # IPhone tools
    install_pkgs ifuse libimobiledevice usbmuxd
}

function do_configure() {
    systemctl enable bluetooth
    
    idem_rsync "$SRC_DIR/etc/bluetooth/main.conf" "/etc/bluetooth/main.conf"

    true
}

