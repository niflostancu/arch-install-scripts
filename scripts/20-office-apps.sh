#!/bin/bash
#
# Installs Office & EBook apps, printer drivers etc.

function do_install_prerequisites() {
    install_pkgs libreoffice-fresh calibre

    # Printers
    install_pkgs cups cups-pk-helper system-config-printer ghostscript

    install_pkgs --aur ttf-vista-fonts

    if [[ -n "$INSTALL_PRINTER_DRIVERS" ]]; then
        install_pkgs foomatic-db-engine gutenprint gsfonts \
            foomatic-db foomatic-db-ppds foomatic-db-nonfree-ppds ghostscript
    fi

    # Tex Live
    if [[ -n "$INSTALL_LATEX" ]]; then
        install_pkgs texlive-core texlive-bin texlive-science texlive-pictures \
            texlive-latexextra texlive-bibtexextra biber tex-gyre-fonts otf-stix
    fi
    # Tectonic XeTeX distribution
    install_pkgs tectonic

    # Documentation / tools
    install_pkgs man-pages man-db asciinema ghostwriter
}

function do_configure() {
    sudo systemctl enable cups
    sudo systemctl start cups || true
}

