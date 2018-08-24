#!/bin/bash
# Implements the module execution unit.

# Executes all scripts inside the specified dir
function execute_all() {
    while IFS=  read -r -d $'\0' file; do
        execute_script "$file"
    done < <(find "$1" '(' -iname '*.sh' ')' -print0 | sort -n -z)
}

# Executes a named script
function execute_script() {
    unset -f do_install_prerequisites
    unset -f do_install_secondary
    unset -f do_configure
    local NAME=$(basename "$1")
    
    echo
    information "Running script $NAME ..."
    source "$1"
    
    if function_exists do_install_prerequisites; then
        information "[$NAME] Installing prerequisites..."
        set +e
        if ! do_install_prerequisites; then
            show_pkg_warnings
            error "[$NAME] Prerequisites installation failed!"
            set -e
            return 0
        fi
        set -e
        show_pkg_warnings
    fi

    if function_exists do_install_secondary; then
        information "[$NAME] Installing secondary packages..."
        set +e
        if ! do_install_secondary; then
            show_pkg_warnings
            error "[$NAME] Installation script failed!"
            set -e
            return 0
        fi
        set -e
        show_pkg_warnings
    fi

    if function_exists do_configure; then
        information "[$NAME] Configuring the system..."
        set +e
        if ! do_configure; then
            error "[$NAME] Configuration failed!"
            set -e
            return 0
        fi
        set -e
    fi
}

