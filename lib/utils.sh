#!/bin/bash
# Contains utility functions

# debug enabled flag
DEBUG=${DEBUG:-}

# The following function prints a text using custom color
# -c or --color define the color for the print. See the array colors for the available options.
# -n or --noline directs the system not to print a new line after the content.
# https://bytefreaks.net/gnulinux/bash/cecho-a-function-to-print-using-different-colors-in-bash
function cecho() {
    declare -A colors
    colors=(
        ['black']='\E[0;47m'
        ['red']='\E[0;31m'
        ['green']='\E[0;32m'
        ['yellow']='\E[0;33m'
        ['blue']='\E[0;34m'
        ['magenta']='\E[0;35m'
        ['cyan']='\E[0;36m'
        ['gray']='\E[0;37m'
    )

    local color=${color:-black}
    local newLine=${newLine:-true}
    while [[ $# -gt 1 ]]; do
        case "$1" in
            -c|--color)
                color="$2";
                shift;
                ;;
            -n|--noline)
                newLine=false;
                ;;
            --)
                shift; break
                ;;
            *)
                break
                ;;
        esac
        shift;
    done

    echo -en "${colors[$color]}";
    echo -en "$@";
    if [ "$newLine" = true ] ; then
        echo;
    fi
    tput sgr0  # Reset text attributes to normal without clearing screen
}

function log_debug() {
    [[ -n "$DEBUG" ]] || return 0
    cecho -c 'gray' "$@"
}
function log_info() { cecho -c 'blue' "$@"; }
function log_warn() { cecho -c 'yellow' "$@"; }
function log_error() { cecho -c 'red' "$@"; }


function function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

