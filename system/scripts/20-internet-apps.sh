#!/bin/bash
#
# Installs Internet apps

function do_install_prerequisites() {
    install_pkgs chromium firefox transmission-qt transmission-cli pidgin \
        purple-facebook
    install_yaourt_pkgs purple-hangouts-hg
    install_yaourt_pkgs seafile seafile-client
    install_yaourt_pkgs rambox-bin
}

