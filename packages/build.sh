#!/bin/bash
# Flexible ArchLinux package builder script

set -eo pipefail
source "$(dirname -- "${BASH_SOURCE[0]}")/../lib/base.sh"
SRC_DIR=$(sh_get_script_path)

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

MAKEPKG_ARGS=(-s)
DRY_RUN=
DIST_CLEAN=
MAKEPKG_CONF_EXTRA=

while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            _print_help ;;
        --distclean)
            DIST_CLEAN=1 ;;
        --force|-f)
            MAKEPKG_ARGS+=(--force) ;;
        --cleanbuild|-C)
            MAKEPKG_ARGS+=(--cleanbuild) ;;
        --install|-i)
            MAKEPKG_ARGS+=(--install) ;;
        -*)
            sh_log_error "Invalid argument: $1" >&2
            _print_help ;;
        *) break ;;
    esac
    shift
done
[[ $# -gt 0 ]] || _print_help
if [[ "$EUID" -eq 0 ]]; then
    sh_log_error "Please DO NOT run this as root!"; exit 1
fi

function build_configure() {
    cat <<EOF > "$BUILD_DIR/makepkg.conf"
source /etc/makepkg.conf
# BUILDDIR="${BUILD_DIR}/build"
# PKGDEST="${BUILD_DIR}/pkg"
# SRCDEST="${BUILD_DIR}/sources"
# SRCPKGDEST="${BUILD_DIR}/sources"
PKGEXT='.pkg.tar.zst'
SRCEXT='.src.tar.gz'
${MAKEPKG_CONF_EXTRA}
EOF
    MAKEPKG_ARGS+=(--config "$BUILD_DIR/makepkg.conf")
}

# Downloads an ABS / AUR package (using yay)
function download_arch_pkg() {
    yay -G "$1"
}

# downloads / patches / builds a package
function build_arch_package() {
    local PKG_SOURCE="$SRC_DIR/$1"
    local PKG_BUILD_DEST="$BUILD_DIR/$1"
    (
        cd "$BUILD_DIR"
        if [[ -n "$DIST_CLEAN" && -d "$PKG_BUILD_DEST" ]]; then
            rm -rf "$PKG_BUILD_DEST"
        fi
        if [[ ! -f "$PKG_SOURCE/PKGBUILD" ]]; then
            sh_log_info "Downloading $1 src:"
            download_arch_pkg "$1"
        fi
        # copy the package source to the build destination
        rsync -rvh --times --mkpath "$PKG_SOURCE/" "$PKG_BUILD_DEST/"
        cd "$PKG_BUILD_DEST"

        # check for PKGBUILD* patches
        shopt -s nullglob
        for pfile in PKGBUILD*.patch; do
	        if ! patch -R -p1 -s -f --dry-run < "$pfile"; then
		        sh_log_info "Applied patch: $pfile"
		        patch -p1 < "$pfile"
		    else
		        sh_log_debug "Ignored patch: $pfile"
	        fi
        done

        sh_log_info "Building $1"
        if [[ -f "build.hook.sh" ]]; then
            sh_log_debug "loading build.hook.sh"
            source "./build.hook.sh"
        else
            build_configure
        fi
        sh_log_debug makepkg "${MAKEPKG_ARGS[@]}"
        makepkg "${MAKEPKG_ARGS[@]}"
    )
}

# change working directory
mkdir -p "$BUILD_DIR"
cd "$BUILD_DIR"

for name in "$@"; do
    if [[ -d "$SRC_DIR/$name" ]]; then
        build_arch_package "$name"
    else
        sh_log_error "Unsupported package: $name"
        exit 1
    fi
done
