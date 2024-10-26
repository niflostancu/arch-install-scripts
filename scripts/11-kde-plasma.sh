#!/bin/bash
# Desktop environment install script for KDE Plasma

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta plasma-nm kde-gtk-config kmenuedit xsettingsd
    install_pkgs kde-multimedia-meta kde-network-meta kde-system-meta kde-utilities-meta \
        power-profiles-daemon kwallet-pam
    install_pkgs ffmpegthumbs juk dragon audiocd-kio kamoso plasmatube
    install_pkgs colord-kde kamera gwenview kdegraphics-thumbnailers kcolorchooser \
        kolourpaint skanlite spectacle okular kruler
    # wayland!
    install_pkgs plasma-wayland-session egl-wayland wl-clipboard
    # Misc apps
    install_pkgs rsibreak redshift kwin-bismuth
}

function do_configure() {
    # TODO: generate autologin conf from template
    # idem_rsync_conf "sddm.conf.d/" "/etc/sddm.conf.d/"
    systemctl enable sddm
}

