#!/bin/bash
#
# Installs Internet apps

function do_install_prerequisites() {
    install_pkgs chromium firefox transmission-qt transmission-cli
    install_pkgs syncthing nextcloud-client
    # install_pkgs --aur signald libpurple-signald purple-gowhatsapp-git
    # Instant messaging
    install_pkgs discord signal-desktop caprine neochat
    install_pkgs --aur slack-desktop teams-for-linux

    # Email clients
    install_pkgs notmuch msmtp neomutt astroid protonmail-bridge-core offlineimap afew
    install_pkgs --aur dodo-mail-git lieer-git
}

