#!/bin/bash
# Desktop environment install script for KDE Plasma

function do_install_prerequisites() {
    install_pkgs sddm plasma-meta plasma-nm nm-connection-editor kde-gtk-config \
        kmenuedit xsettingsd greetd greetd-tuigreet
    install_pkgs kde-multimedia-meta kde-network-meta kde-system-meta kde-utilities-meta \
        power-profiles-daemon kwallet-pam
    install_pkgs ffmpegthumbs juk dragon audiocd-kio kamoso plasmatube
    install_pkgs colord-kde kamera gwenview kdegraphics-thumbnailers kcolorchooser \
        kolourpaint skanlite spectacle okular kruler
    # wayland utils
    install_pkgs egl-wayland 
    install_pkgs --aur wl-clipboard-git
    # QT5 Plasma Integration
    install_pkgs plasma5-integration kwayland5 oxygen5
    # Misc apps
    install_pkgs rsibreak redshift
}

function do_configure() {
    if [[ "$USE_LOGIN_MANAGER" == "sddm" ]]; then
        systemctl disable greetd
        systemctl enable sddm
    elif [[ "$USE_LOGIN_MANAGER" == "greetd" ]]; then
        mkdir -p /etc/greetd
        idem_rsync_conf "greetd/" "/etc/greetd/"
        systemctl disable sddm
        systemctl enable greetd
    fi
}

