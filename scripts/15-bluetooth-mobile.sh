#!/bin/bash
#
# Installs Bluetooth & Mobile tools

function do_install_prerequisites() {
    # Bluetooth
    install_pkgs bluez bluez-libs bluez-utils
    # IPhone tools
    #install_pkgs libimobiledevice usbmuxd
    install_pkgs --aur libimobiledevice-git libplist-git libimobiledevice-glue-git usbmuxd-git ifuse
}

function do_configure() {
    systemctl enable bluetooth

    if idem_rsync_conf "bluetooth/" "/etc/bluetooth/"; then
        systemctl restart bluetooth
    fi
    true
}

