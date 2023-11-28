#!/bin/bash
#
# Installs Internet apps

function do_install_prerequisites() {
    install_pkgs chromium firefox transmission-qt transmission-cli pidgin \
        purple-facebook
    install_pkgs syncthing nextcloud-client
    # install_pkgs --aur signald libpurple-signald purple-gowhatsapp-git
    # Instant messaging
    install_pkgs discord signal-desktop caprine neochat
    install_pkgs --aur slack-desktop

    # Email clients
    install_pkgs notmuch msmtp neomutt astroid offlineimap afew
    install_pkgs --aur python-installer lieer-git muchsync mailctl-bin
}

