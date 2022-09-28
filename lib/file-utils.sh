#!/bin/bash
# Contains file search / copy utilities

declare -g -a CONF_DIRS=("$SRC_DIR/profiles/$PROFILE/etc" "$SRC_DIR/etc")

# Finds a configuration file in either profile's directory or
# within the root 'etc/' (less priority).
function find_conf() {
    local _PRINT_ALL=
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "--all" ]]; then
            _PRINT_ALL=1
        else break; fi
        shift
    done
    local _FOUND=
    for dir in "${CONF_DIRS[@]}"; do
        if [[ -e "$dir/$1" ]]; then
            echo "$dir/$1"
            _FOUND=1
            [[ -n "$_PRINT_ALL" ]] || return 0
        fi
    done
    [[ -n "$_FOUND" ]]
}

# rsync wrapper with change detection: exits with 0 if there were changes made,
# 1 if error, 120 if nothing was done
# Syntax: idem_rsync [RSYNC_OPTIONS] SOURCE [OVERLAY] DESTINATION
function idem_rsync() {
    local -a _RSYNC_ARGS=(-r --links --times)
    local _RSYNC_CHMOD=
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "-"* ]]; then
            if [[ "$1" == "--chmod"* ]]; then _RSYNC_CHMOD=1; fi
            _RSYNC_ARGS+=("$1");
        else break; fi
        shift
    done
    # default dest. permissions
    [[ -n "$_RSYNC_CHMOD" ]] || _RSYNC_ARGS+=("--chmod=D775,F664")
    [[ -z "$DRY_RUN" ]] || _RSYNC_ARGS+=("--dry-run")

    _RSYNC_ARGS=("${_RSYNC_ARGS[@]}" --itemize-changes "$@")
    log_debug "rsync ${_RSYNC_ARGS[@]}"
    local _OUTPUT=
    _OUTPUT=$(rsync "${_RSYNC_ARGS[@]}")
    if [[ "$?" -eq 0 ]]; then
        if [ -n "${_OUTPUT}" ]; then
            echo "$_OUTPUT"
            [[ -z "$DRY_RUN" ]] || return 120
            return 0
        else
            return 120
        fi
    else
        log_error "rsync failed: $_OUTPUT"
        return 1
    fi
}

# Idempotent rsync call for installing configuration files
# (combines `idem_rsync` and `find_conf`)
# If given a directory, allows specifying whether to rsync files from all
# conf search paths (`--all`).
# Separate rsync arguments using '--'.
function idem_rsync_conf() {
    local _PRINT_ALL=
    local _CONF_SRC=
    local _OPTIONAL=
    local -a _RSYNC_ARGS
    local -a _RSYNC_AFTER
    while [[ $# -gt 0 ]]; do
        case "$1" in
            --all) _PRINT_ALL=--all; ;;
            --opt|--optional) _OPTIONAL=1; ;;
            --) shift; break; ;;
            *) break; ;;
        esac
        shift
    done
    # extract the rsync source argument
    while [[ $# -gt 0 ]]; do
        if [[ "$1" == "-"* ]]; then
            _RSYNC_ARGS+=("$1")
            shift
        else
            _CONF_SRC="$1"; shift
            _RSYNC_AFTER+=("$@")
            break
        fi
    done

    local -a _SRC_FILES
    IFS=$'\n' _SRC_FILES=($(find_conf $_PRINT_ALL "$_CONF_SRC" || true | tac))
    if [[ -n "$_SRC_FILES" ]]; then
        idem_rsync "${_RSYNC_ARGS[@]}" "${_SRC_FILES[@]}" "${_RSYNC_AFTER[@]}"
        return
    fi
    if [[ -z "$_OPTIONAL" ]]; then
        log_error "Configuration file not found: '$_CONF_SRC'"
        return 1
    fi
    return 120
}

