#!/bin/bash
#
# Installs cloud tools

function do_install_prerequisites() {
    # Prerequisites
    install_pkgs python-crcmod
    # Kubernetes tools
    install_aur_pkgs kubectl k9s
    # Google cloud SDK
    install_aur_pkgs google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin
}

