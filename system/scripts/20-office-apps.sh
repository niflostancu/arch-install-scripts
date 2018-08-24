#!/bin/bash
#
# Installs Office apps, printer drivers etc.

function do_install_prerequisites() {
    install_pkgs libreoffice-fresh

    # Printers
    install_pkgs cups cups-pk-helper system-config-printer foomatic-db-engine \
        foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds ghostscript \
        gutenprint gsfonts

    # Tex Live
    install_pkgs texlive-core texlive-bin texlive-science texlive-pictures
}

function do_configure() {
    sudo systemctl enable org.cups.cupsd.service
    sudo systemctl start org.cups.cupsd.service || true
}

