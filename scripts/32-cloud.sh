#!/bin/bash
#
# Installs cloud tools

function do_install_prerequisites() {
    # Prerequisites
    install_pkgs python-crcmod
    # Kubernetes tools
    install_pkgs kubectl k9s
    # Google Cloud SDK
    install_pkgs --aur google-cloud-sdk google-cloud-sdk-gke-gcloud-auth-plugin
}

