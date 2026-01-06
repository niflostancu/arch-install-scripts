#!/bin/bash
#
# Installs ABS tools & yay AUR package manager

function do_install_prerequisites() {
    install_pkgs base-devel git pkgfile expac

    # check if the aurbuild user exists (we use it for building packages)
    BUILD_HOME=/var/aur-build
    if ! id "$BUILD_USER" >/dev/null 2>/dev/null; then
        mkdir -p "$BUILD_HOME"
        echo "User $BUILD_USER created!"
        useradd -r -d "$BUILD_HOME" "$BUILD_USER"
        chown "$BUILD_USER":"$BUILD_USER" "$BUILD_HOME"
    fi
    echo "$BUILD_USER ALL= (root) NOPASSWD: /usr/bin/pacman " > /etc/sudoers.d/$BUILD_USER
    usermod -aG disk "$BUILD_USER"

    if command -v yay >/dev/null 2>&1 && [[ -z "$FORCE_REINSTALL" ]]; then
        echo "YaY (package manager) already installed! skipping..."
        return 0
    fi

    ! pacman -Qq yay &>/dev/null || return 0

    rm -rf /tmp/yay-install
    run_as_builduser mkdir -p /tmp/yay-install
    (
        cd /tmp/yay-install
        echo "Retrieving yay ..."
        run_as_builduser git clone https://aur.archlinux.org/yay.git
        cd yay
        echo "Installing yay ..."
        run_as_builduser makepkg -si --noconfirm
        echo "Done!"
    )
    rm -rf /tmp/yay-install

    true
}

