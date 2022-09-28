#!/bin/bash
#
# Installs Bluetooth & Mobile tools

function do_install_prerequisites() {
    # Bluetooth
    install_pkgs bluez bluez-libs bluez-utils
    # IPhone tools
    install_pkgs ifuse libimobiledevice usbmuxd
}

function do_configure() {
    systemctl enable bluetooth

    if idem_rsync_conf "bluetooth/" "/etc/bluetooth/"; then
        systemctl restart bluetooth
    fi
    true
}

