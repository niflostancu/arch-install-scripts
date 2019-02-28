#!/bin/bash
#
# Installs yay package manager

function do_install_prerequisites() {
    install_pkgs base-devel git
}

function do_install_secondary() {
    if command -v yay >/dev/null 2>&1; then
        echo "YaY (package manager) already installed! skipping..."
        return 0
    fi

    sudo -u "$SUDO_USER" -- mkdir -p /tmp/yay-install
    pushd /tmp/yay-install
    echo "Retrieving yay ..."
    sudo -u "$SUDO_USER" -- git clone git clone https://aur.archlinux.org/yay.git
    cd yay
    echo "Installing yay ..."
    sudo -u "$SUDO_USER" -- makepkg -si --noconfirm
    echo "Done!"
    popd
    rm -rf /tmp/yay-install

    true
}

