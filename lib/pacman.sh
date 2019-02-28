#!/bin/bash
# Pacman installation helpers

# This array will contain the packages that were not found during the install
# phase
PKG_WARNINGS=()

# Installs the specified packages (best-effort, does not fail if one package
# doesn't exist, just adds to PKG_WARNINGS).
function install_pkgs() {
    local -a pkgs_found
    local -a pkgs_404
    pkgs_found=($(comm -12 <( { pacman -Slq; pacman -Sgq; } | sort -u) <(printf '%s\n' "$@"|sort -u)))
    pkgs_404=($(comm -23 <(printf '%s\n' "$@"|sort -u) <(printf '%s\n' "${pkgs_found[@]}")))
    PKG_WARNINGS+=(${pkgs_404})
    pacman -S --needed --noconfirm "${pkgs_found[@]}"
}

# Installs packages from AUR (uses YaY)
function install_aur_pkgs() {
    sudo -u "$SUDO_USER" -- yay -S --needed --noconfirm "$@"
}

function show_pkg_warnings() {
    for pkgname in "${PKG_WARNINGS[@]}"; do
        warning "WARNING: package $pkgname not found!"
    done
    PKG_WARNINGS=()
}
