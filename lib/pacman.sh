#!/bin/bash
# Pacman installation helpers

# This array will contain the packages that were not found during the install
# phase
PKG_WARNINGS=()
PKG_EXCLUDED=()

# The unprivileged user used for building AUR packages
BUILD_USER=aurbuild

# Installs the specified packages (best-effort, does not fail if one package
# doesn't exist, just adds to PKG_WARNINGS).
function install_pkgs() {
    local -a to_install
    local -a pkgs_404
    local -a pkgs_excluded
    to_install=($(comm -12 <( { pacman -Slq; pacman -Sgq; } | sort -u) <(printf '%s\n' "$@"|sort -u)))
    pkgs_excluded=($(comm -12 <(printf '%s\n' "$@" | sort -u) <(printf '%s\n' "${EXCLUDE_PACKAGES[@]}"|sort -u)))
    pkgs_404=($(comm -23 <(printf '%s\n' "$@"|sort -u) <(printf '%s\n' "${to_install[@]}")))
    to_install=($(comm -23 <(printf '%s\n' "${to_install[@]}" | sort -u) <(printf '%s\n' "${pkgs_404[@]}"|sort -u)))
    to_install=($(comm -23 <(printf '%s\n' "${to_install[@]}" | sort -u) <(printf '%s\n' "${pkgs_excluded[@]}"|sort -u)))
    PKG_WARNINGS+=(${pkgs_404[@]})
    PKG_EXCLUDED+=(${pkgs_excluded[@]})
    [[ "${#to_install}" -gt 0 ]] || return 0
    pacman -S --needed --noconfirm "${to_install[@]}"
}

# Installs packages from AUR (uses YaY)
function install_aur_pkgs() {
    sudo -u "$BUILD_USER" -- yay -S --needed --noconfirm "$@"
}

function show_pkg_warnings() {
    for pkgname in "${PKG_WARNINGS[@]}"; do
        warning "WARNING: package $pkgname excluded!"
    done
    for pkgname in "${PKG_WARNINGS[@]}"; do
        warning "WARNING: package $pkgname not found!"
    done
    PKG_WARNINGS=()
}
