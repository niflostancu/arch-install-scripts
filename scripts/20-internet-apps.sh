#!/bin/bash
#
# Installs Internet apps

function do_install_prerequisites() {
    install_pkgs chromium firefox transmission-qt transmission-cli pidgin \
        purple-facebook
    install_pkgs syncthing nextcloud-client
    install_aur_pkgs signald libpurple-signald purple-gowhatsapp-git
}

