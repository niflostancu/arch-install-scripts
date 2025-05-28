#!/bin/bash
# Pacman installation helpers

# This array will contain the packages that were not found during the install
# phase
declare -g -a _PKGMAN_WARNINGS=()
declare -g -a _PKGMAN_EXCLUDED=()

# The unprivileged user used for building AUR packages
BUILD_USER=aurbuild

# Installs the specified packages (best-effort, does not fail if one package
# doesn't exist, just adds to PKG_WARNINGS).
function install_pkgs() {
    local PKG_AUR=
    local -a PKGS_TO_INSTALL
    local -a PKGS_404
    local -a PKGS_EXCLUDED
    local -a PACMAN_ARGS=(--noconfirm)

    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "--aur" ]]; then
            PKG_AUR=1
        else break; fi
        shift
    done
    PKGS_TO_INSTALL=("$@")
    if [[ -z "$PKG_AUR" ]]; then
        PKGS_TO_INSTALL=($(comm -12 <( { pacman -Slq; pacman -Sgq; } | sort -u) <(printf '%s\n' "$@"|sort -u)))
    fi
    if [[ -z "$FORCE_REINSTALL" && -z "$PKG_AUR" ]]; then
        PACMAN_ARGS+=("--needed")
        # exclude already installed packages from the arguments
        # (to prevent pacman showing warnings)
        PKGS_TO_INSTALL=($(comm -23 <(printf '%s\n' "${PKGS_TO_INSTALL[@]}" | sort -u) <(pacman -Qq | sort -u)))
    fi
    PKGS_EXCLUDED=($(comm -12 <(printf '%s\n' "$@" | sort -u) <(printf '%s\n' "${EXCLUDE_PACKAGES[@]}"|sort -u)))
    PKGS_404=($(comm -23 <(printf '%s\n' "$@"|sort -u) <(printf '%s\n' "${PKGS_TO_INSTALL[@]}")))
    sh_log_debug "install_pkgs: [${PKGS_TO_INSTALL[@]}]; NOT_FOUND=[${PKGS_404[@]}]; EXCLUDE=[${PKGS_EXCLUDED[@]}]!"
    PKGS_TO_INSTALL=($(comm -23 <(printf '%s\n' "${PKGS_TO_INSTALL[@]}" | sort -u) <(printf '%s\n' "${PKGS_404[@]}"|sort -u)))
    PKGS_TO_INSTALL=($(comm -23 <(printf '%s\n' "${PKGS_TO_INSTALL[@]}" | sort -u) <(printf '%s\n' "${PKGS_EXCLUDED[@]}"|sort -u)))

    _PKGMAN_WARNINGS+=(${PKGS_404[@]})
    _PKGMAN_EXCLUDED+=(${PKGS_EXCLUDED[@]})
    if [[ -n "$DRY_RUN" ]]; then
        [[ ${#PKGS_TO_INSTALL[@]} -gt 0 ]] || return 0
        echo -n "Packages to install: ${PKGS_TO_INSTALL[@]}"
        [[ -z "$PKG_AUR" ]] || echo -n "[AUR]"
        echo
        return 0
    fi
    [[ "${#PKGS_TO_INSTALL}" -gt 0 ]] || {
        return 0
    }
    if [[ -n "$PKG_AUR" ]]; then
        sh_log_debug yay -S "${PACMAN_ARGS[@]}" "${PKGS_TO_INSTALL[@]}"
        sudo -u "$BUILD_USER" -- yay -S "${PACMAN_ARGS[@]}" "${PKGS_TO_INSTALL[@]}"
    else
        sh_log_debug pacman -S "${PACMAN_ARGS[@]}" "${PKGS_TO_INSTALL[@]}"
        pacman -S "${PACMAN_ARGS[@]}" "${PKGS_TO_INSTALL[@]}"
    fi
}

function show_pkg_warnings() {
    if [[ "${#PKGMAN_EXCLUDED[@]}" -gt 0 ]]; then
        sh_log_debug "DBG: packages excluded: ${PKGMAN_EXCLUDED[@]}!"
    fi
    for pkgname in "${PKGMAN_WARNINGS[@]}"; do
        sh_log_error "WARNING: package $pkgname not found!"
    done
    PKGMAN_WARNINGS=()
    PKGMAN_EXCLUDED=()
}
