#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Password Management
    install_pkgs keepassxc

    # File formats / utilities
    install_pkgs zip unzip p7zip sqlite

    # Reverse engineering
    install_pkgs radare2 iaito r2ghidra
    # install_pkgs ghidra

    # Network tools
    install_pkgs bind-tools nmap aircrack-ng traceroute wireshark-qt wol \
        lftp whois iperf iperf3 dsniff tcpdump arp-scan tftp-hpa bind-tools \
        termshark ldns bind

    # System monitoring
    install_pkgs htop iotop powertop pacutils glances fastfetch

    # Crypto / forensics
    install_pkgs ophcrack john hashcat foremost testdisk easy-rsa \
        strace

    # Misc tools
    install_pkgs gnuplot rlwrap powertop dmidecode diff-so-fancy \
        units gparted jq
    #install_pkgs --aur shc
}

