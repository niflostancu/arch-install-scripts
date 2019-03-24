#!/bin/bash
#
# Installs cloud tools

function do_install_prerequisites() {
    # Google cloud SDK
    install_aur_pkgs google-cloud-sdk
    # Kubernetes tools
    install_aur_pkgs kubectl-bin
}

