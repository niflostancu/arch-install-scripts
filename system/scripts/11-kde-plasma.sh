#!/bin/bash
#
# Installs KDE & PlasmaShell

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta kde-applications-meta plasma-nm breeze-kde4
    # Misc apps
    install_pkgs rsibreak redshift plasma5-applets-redshift-control 
    install_yaourt_pkgs diskmonitor
}

function do_configure() {
    if [[ ! -f /etc/sddm.conf ]]; then
        copy_config "$" "/etc/sddm.conf"
    fi
    systemctl enable sddm

    true
}

