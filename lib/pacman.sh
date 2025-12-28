#!/bin/bash
# Pacman installation helpers

# This array will contain the packages that were not found during the install
# phase
declare -g -a _PKGMAN_WARNINGS=()
declare -g -a _PKGMAN_EXCLUDED=()

# The unprivileged user used for building AUR packages
BUILD_USER=aurbuild
BUILD_CACHE_SRC="/home/$BUILD_USER/.cache/arch-build/_arch_src"

# Installs the specified packages (best-effort, does not fail if one package
# doesn't exist, just adds to PKG_WARNINGS).
function install_pkgs() {
    local ENABLE_AUR=
    local -a PKGS_REPO PKGS_REPO_FILTERED PKGS_NOTFOUND PKGS_EXCLUDED PKGS_AUR
    local -a PACMAN_ARGS=(--noconfirm)

    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "--aur" ]]; then
            ENABLE_AUR=1
        else break; fi
        shift
    done
    # remove globally-excluded packages
    mapfile -t PKGS_EXCLUDED < <(pkgs_array_sorted "${EXCLUDE_PACKAGES[@]}" | pkg_list_filter --same "${@}")
    mapfile -t PKGS_REPO < <(pkgs_array_sorted "${EXCLUDE_PACKAGES[@]}" | pkg_list_filter "${@}")
    if [[ -n "$ENABLE_AUR" ]]; then
        # split out AUR-only packages (to be installed separately using yay)
        mapfile -t PKGS_AUR < <(yay -Sqla|sort -u | \
            pkg_list_filter --same "${PKGS_REPO[@]}")
        mapfile -t PKGS_REPO < <(pkgs_array_sorted "${PKGS_AUR[@]}" | \
            pkg_list_filter "${PKGS_REPO[@]}")
    fi
    # extract only packages found inside synced repos
    mapfile -t PKGS_REPO_FILTERED < <(pacman_query -Sqlg | \
        pkg_list_filter --same "${PKGS_REPO[@]}")
    mapfile -t PKGS_NOTFOUND < <(pkgs_array_sorted "${PKGS_REPO_FILTERED[@]}" | \
        pkg_list_filter "${PKGS_REPO[@]}")

    # only filter out already present AUR packages if reinstall was not forced
    if [[ -z "$FORCE_REINSTALL" ]]; then
        PACMAN_ARGS+=("--needed")
        # exclude already installed packages from the arguments
        # (to prevent pacman showing warnings)
        mapfile -t PKGS_REPO_FILTERED < <(pacman_query -Qq | pkg_list_filter "${PKGS_REPO_FILTERED[@]}")
        if [[ ${#PKGS_AUR[@]} -gt 0 ]]; then
            # also filter out already installed AUR packages (marked as foreign by pacman)
            mapfile -t PKGS_AUR < <(pacman_query -Qmq | pkg_list_filter "${PKGS_AUR[@]}")
        fi
    fi

    sh_log_debug "install_pkgs [$(pkgs_array_inline "$@")];" \
        "repo=[$(pkgs_array_inline "${PKGS_REPO_FILTERED[@]}")];" \
        "aur=[$(pkgs_array_inline "${PKGS_AUR[@]}")];" \
        "NOT_FOUND=[$(pkgs_array_inline "${PKGS_NOTFOUND[@]}")]"

    _PKGMAN_WARNINGS+=("${PKGS_NOTFOUND[@]}")
    _PKGMAN_EXCLUDED+=("${PKGS_EXCLUDED[@]}")
    if [[ "${#PKGS_REPO_FILTERED}" -gt 0 ]]; then
        sh_log_debug pacman -S "${PACMAN_ARGS[@]}" "${PKGS_REPO_FILTERED[@]}"
        if [[ -n "$DRY_RUN" ]]; then
            sh_log_info "Install pkgs: $(pkgs_array_inline "${PKGS_REPO_FILTERED[@]}")"
        else
            pacman -S "${PACMAN_ARGS[@]}" "${PKGS_REPO_FILTERED[@]}"
        fi
    fi
    if [[ "${#PKGS_AUR[@]}" -gt 0 ]]; then
        sh_log_debug yay -S "${PACMAN_ARGS[@]}" "${PKGS_AUR[@]}"
        if [[ -n "$DRY_RUN" ]]; then
            sh_log_info "Install pkgs [AUR]: $(pkgs_array_inline "${PKGS_AUR[@]}")"
        else
            PACMAN_ARGS+=("${PACMAN_ARGS[@]}" --answerclean=None --answerdiff=None 
                --answeredit=None --answerupgrade=None)
            PACMAN_ARGS=("${PACMAN_ARGS[@]/--noconfirm}")
            sudo -u "$BUILD_USER" -- sh -c 'yes | $@' -- yay -S "${PACMAN_ARGS[@]}" "${PKGS_AUR[@]}"
        fi
    fi
}

function check_pkg_installed() {
    pacman -q -Qi "$@" &>/dev/null
}

function pacman_query() {
    local PAC_ARGS=()
    local _QUERY_LIST='' _QUERY_GROUPS=''
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == --* ]]; then PAC_ARGS+=("$1")
        elif [[ "$1" =~ ^-[a-zA-Z]* ]]; then
            local ARG="$1"
            if [[ "$1" == *l* ]]; then ARG="${ARG//l/}"; _QUERY_LIST=1; fi
            if [[ "$1" == *g* ]]; then ARG="${ARG//g/}"; _QUERY_GROUPS=1; fi
            [[ "$ARG" == '-' ]] || PAC_ARGS+=("$ARG")
        else break; fi; shift
    done
    {
        if [[ -n "$_QUERY_LIST" ]]; then pacman "${PAC_ARGS[@]}" -l; fi
        if [[ -n "$_QUERY_GROUPS" ]]; then pacman "${PAC_ARGS[@]}" -g; fi
        if [[ -z "$_QUERY_LIST" && -z "$_QUERY_GROUPS" ]]; then pacman "${PAC_ARGS[@]}"; fi
    } | sort -u | awk NF
}

function pkgs_array_sorted() {
    printf '%s\n' "$@" | sort -u | awk NF
}

function pkgs_array_inline() {
    local TMP=""
    printf -v TMP '%s ' "$@"
    echo -n "${TMP%?}"
}

function pkg_list_filter() {
    local -a COMM_ARGS=()
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "--same" ]]; then
            COMM_ARGS+=(-12)
        elif [[ "$1" == -* ]]; then
            sh_log_error "pkg_list_filter: invalid argument: $1"; return 1
        else break; fi; shift
    done
    [[ -n "${COMM_ARGS[*]}" ]] || COMM_ARGS=("-23")
    comm "${COMM_ARGS[@]}" <(printf '%s\n' "$@" | sort -u | awk NF) "-" | awk NF
}

function show_pkg_warnings() {
    if [[ "${#_PKGMAN_EXCLUDED[@]}" -gt 0 ]]; then
        sh_log_info "NOTICE: Packages excluded:" "${_PKGMAN_EXCLUDED[@]}"
    fi
    for pkgname in "${_PKGMAN_WARNINGS[@]}"; do
        sh_log_error "WARNING: package $pkgname not found!"
    done
    _PKGMAN_WARNINGS=()
    _PKGMAN_EXCLUDED=()
}

function run_as_builduser() {
    sudo -u "$BUILD_USER" -- "$@"
}

# builds custom package from source (from the packages/ directory)
# uses the included build.sh wrapper
function build_custom_pkg() {
    # rsync some source code to the BUILD_USER
    rsync -rlptD --chown="$BUILD_USER:$BUILD_USER" --mkpath \
        "$SRC_DIR/lib" "$SRC_DIR/packages" "$BUILD_CACHE_SRC/"
    run_as_builduser "$BUILD_CACHE_SRC/packages/build.sh" "$@"
}

