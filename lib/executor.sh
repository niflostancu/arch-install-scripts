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
    sh_log_info "Running script $NAME ..."
    source "$1"
    
    if sh_is_function do_install_prerequisites; then
        sh_log_info "[$NAME] Installing prerequisites..."
        set +e
        if ! do_install_prerequisites; then
            show_pkg_warnings
            sh_log_error "[$NAME] Prerequisites installation failed!"
            set -e
            return 0
        fi
        set -e
        show_pkg_warnings
    fi

    if sh_is_function do_configure; then
        sh_log_info "[$NAME] Configuring the system..."
        set +e
        if ! do_configure; then
            sh_log_error "[$NAME] Configuration failed!"
            set -e
            return 0
        fi
        set -e
    fi
}

