#!/bin/bash
# Desktop environment install script for KDE Plasma

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta kde-applications-meta plasma-nm \
        kde-gtk-config packagekit-qt5 kmenuedit
    # wayland!
    install_pkgs plasma-wayland-session egl-wayland wl-clipboard
    # Misc apps
    install_pkgs rsibreak redshift 
    install_pkgs --aur diskmonitor plasma5-applets-eventcalendar
}

function do_configure() {
    # TODO: generate autologin conf from template
    # idem_rsync_conf "sddm.conf.d/" "/etc/sddm.conf.d/"
    systemctl enable sddm
}

