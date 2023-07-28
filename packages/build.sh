#!/bin/bash
# Script to build custom ArchLinux packages
set -e

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$SRC_DIR/../lib/utils.sh"

BUILD_DIR=${BUILD_DIR:-$HOME/.cache/arch-build}

# parse command line arguments
_print_help() {
    echo "Syntax: $0 [options...] [PACKAGE_DIR]"
    echo "Options:"
    echo "   --force|-f: forces rebuilding the package"
    echo "   --cleanbuild|-C: forces a clean build"
    echo "   --install|-i: installs the package after successful build"
    exit 1
}

MAKEPKG_ARGS=()
DRY_RUN=
MAKEPKG_CONF_EXTRA=

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            _print_help; exit 1 ;;
        --force|-f)
            MAKEPKG_ARGS+=(--force) ;;
        --cleanbuild|-C)
            MAKEPKG_ARGS+=(--cleanbuild) ;;
        --install|-i)
            MAKEPKG_ARGS+=(--install) ;;
        -*)
            echo "Invalid argument: $1" >&2
            _print_help; exit 1
            ;;
        *) break ;;
    esac
    shift
done
[[ -n "$@" ]] || _print_help
if [[ "$EUID" -eq 0 ]]; then
    _print_help
    echo "Please DO NOT run this as root!"
    exit 1
fi

mkdir -p "$BUILD_DIR"

function build_config() {
    cat <<EOF > "$BUILD_DIR/makepkg.conf"
source /etc/makepkg.conf
BUILDDIR="${BUILD_DIR}/build"
PKGDEST="${BUILD_DIR}/pkg"
SRCDEST="${BUILD_DIR}/sources"
SRCPKGDEST="${BUILD_DIR}/sources"
PKGEXT='.pkg.tar.zst'
SRCEXT='.src.tar.gz'
${MAKEPKG_CONF_EXTRA}

EOF
    MAKEPKG_ARGS+=(--config "$BUILD_DIR/makepkg.conf")
}

function build_arch_package() {
    (
        cd "$SRC_DIR/$1"
        log_info "Building $1"
        if [[ -f build.conf.sh ]]; then
            log_debug loading build.conf.sh
            source build.conf.sh
        fi
        build_config
        log_debug makepkg "${MAKEPKG_ARGS[@]}"
        makepkg "${MAKEPKG_ARGS[@]}"
    )
}

for name in "$@"; do
    if [[ -f "$SRC_DIR/$1/PKGBUILD" ]]; then
        build_arch_package "$name"
    else
        echo "Invalid package: $name!"
    fi
done
