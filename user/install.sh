#!/bin/bash
#
# X11 / KDE auto configuration script.
# To be ran as the user you want to configure!

set -e

SRC_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
. "$SRC_DIR/../lib/utils.sh"
. "$SRC_DIR/../lib/conf-utils.sh"
. "$SRC_DIR/../lib/copy-utils.sh"
. "$SRC_DIR/../lib/executor.sh"

if [[ "$EUID" -eq 0 ]]; then
	echo "Please DONT run as root!"
	exit 1
fi

XDG_CONFIG_HOME="${XDG_CONFIG_HOME:-$HOME/.config}"
XDG_DATA_HOME="${XDG_DATA_HOME:-$HOME/.local/share}"

PROFILE="$(cat /etc/machine-type | head -n 1)"

if [[ -z "$PROFILE" ]]; then
	echo "Please fill out /etc/machine-type with the machine's profile name!"
	exit 1
fi

if [[ -z "$@" ]]; then
	execute_all "./scripts"
elif [[ -f "$1" ]]; then
	execute_script "$1"
else
	echo "Invalid parameter!"
fi

