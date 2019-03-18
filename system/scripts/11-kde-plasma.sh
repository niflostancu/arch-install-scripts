#!/bin/bash
#
# Installs KDE & PlasmaShell

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta kde-applications-meta plasma-nm \
        kde-gtk-config
    # Misc apps
    install_pkgs rsibreak redshift plasma5-applets-redshift-control 
    install_aur_pkgs diskmonitor plasma5-applets-eventcalendar
}

function do_configure() {
    idem_rsync "$SRC_DIR/etc.$PROFILE/sddm.conf" "/etc/sddm.conf"
    systemctl enable sddm
}

