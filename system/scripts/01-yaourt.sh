#!/bin/bash
#
# Installs yaourt package manager

function do_install_prerequisites() {
    install_pkgs base-devel git
}

function do_install_secondary() {
    if command -v yaourt >/dev/null 2>&1; then
        echo "Yaourt already installed! skipping..."
        return 0
    fi

    sudo -u "$SUDO_USER" -- mkdir -p /tmp/yaourt-install
    pushd /tmp/yaourt-install
    echo "Retrieving package-query ..."
    sudo -u "$SUDO_USER" -- git clone https://aur.archlinux.org/package-query.git
    cd package-query
    echo "Installing package-query ..."
    sudo -u "$SUDO_USER" -- makepkg -si --noconfirm
    cd ..
    echo "Retrieving yaourt ..."
    sudo -u "$SUDO_USER" -- git clone https://aur.archlinux.org/yaourt.git
    cd yaourt
    echo "Installing yaourt ..."
    sudo -u "$SUDO_USER" -- makepkg -si --noconfirm
    echo "Done!"
    popd
    rm -rf /tmp/yaourt-install

    true
}

