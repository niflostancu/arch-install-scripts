#!/bin/bash
# Scripts for managing an Arch Linux system install
# Unified packages and configs supporting multiple profiles.

set -e

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$SRC_DIR/lib/utils.sh"

# parse command line arguments
_print_help() {
    echo "Syntax: $0 [options...] [SCRIPT_NAME]"
    echo "Options:"
    echo "   --debug|-d: enables debug printing"
    echo "   --force|-f: forces reinstalling / copying everything"
    echo "   --dry-run|-n: does a dry run (does not modify anything)"
}

FORCE_REINSTALL=
DRY_RUN=
while [[ $# -gt 0 ]]; do
    case "$1" in
        --help|-h)
            _print_help; exit 1 ;;
        --debug|-d)
            DEBUG=1 ;;
        --force|-f)
            FORCE_REINSTALL=1 ;;
        --dry-run|-n)
            DRY_RUN=1 ;;
        -*)
            echo "Invalid argument: $1" >&2
            _print_help; exit 1
            ;;
        *) break ;;
    esac
    shift
done
if [[ "$EUID" -ne 0 ]]; then
    _print_help
    echo "Please run as root!"
    exit 1
fi

PROFILE="$(cat /etc/machine-profile | head -n 1)"
if [[ -z "$PROFILE" ]]; then
    echo "Please fill out /etc/machine-profile with the machine's profile name!" >&2
    echo "You can use './set-machine-profile.sh PROFILE' to do that." >&2
    exit 1
fi

source "$SRC_DIR/profiles/$PROFILE/profile.sh"

. "$SRC_DIR/lib/file-utils.sh"
. "$SRC_DIR/lib/pacman.sh"
. "$SRC_DIR/lib/executor.sh"

if [[ -z "$@" ]]; then
    execute_all "./scripts"
elif [[ -f "$1" ]]; then
    execute_script "$1"
else
    echo "Invalid parameter!"
fi
