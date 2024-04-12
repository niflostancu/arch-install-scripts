#!/bin/bash
# Desktop environment install script for KDE Plasma

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta plasma-nm kde-gtk-config packagekit-qt5 kmenuedit xsettingsd
    install_pkgs kde-multimedia-meta kde-network-meta kde-system-meta kde-utilities-meta \
        kimageformats5 power-profiles-daemon kwallet-pam
    # wayland!
    install_pkgs plasma-wayland-session egl-wayland wl-clipboard
    # Misc apps
    install_pkgs rsibreak redshift kwin-bismuth
    install_pkgs --aur plasma-active-accent-frame-decorations
    #install_pkgs --aur plasma5-applets-eventcalendar
}

function do_configure() {
    # TODO: generate autologin conf from template
    # idem_rsync_conf "sddm.conf.d/" "/etc/sddm.conf.d/"
    systemctl enable sddm
}

