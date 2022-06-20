#!/bin/bash
#
# Installs Office apps, printer drivers etc.

function do_install_prerequisites() {
    install_pkgs libreoffice-fresh

    # Printers
    install_pkgs cups cups-pk-helper system-config-printer ghostscript

    install_aur_pkgs ttf-vista-fonts

    if [[ -n "$INSTALL_PRINTER_DRIVERS" ]]; then
        install_pkgs foomatic-db-engine gutenprint gsfonts \
            foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds ghostscript
    fi

    # Tex Live
    if [[ -n "$INSTALL_LATEX" ]]; then
        install_pkgs texlive-core texlive-bin texlive-science texlive-pictures \
            texlive-latexextra texlive-bibtexextra biber tex-gyre-fonts otf-stix
    fi
}

function do_configure() {
    sudo systemctl enable org.cups.cupsd.service
    sudo systemctl start org.cups.cupsd.service || true
}

