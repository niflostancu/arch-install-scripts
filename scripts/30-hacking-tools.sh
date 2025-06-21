#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # Password Management
    install_pkgs keepassxc

    # File formats / utilities
    install_pkgs zip unzip 7zip sqlite unrar

    # Reverse engineering
    install_pkgs radare2 iaito r2ghidra binsider
    # install_pkgs ghidra

    # Network tools
    install_pkgs nmap aircrack-ng traceroute wireshark-qt wol whois iperf iperf3 \
        dsniff tcpdump arp-scan lftp tftp-hpa termshark ldns bind

    # System monitoring
    install_pkgs htop iotop powertop pacutils glances fastfetch

    # Crypto / forensics
    install_pkgs john hashcat foremost testdisk easy-rsa strace

    # Misc tools
    install_pkgs gnuplot rlwrap powertop dmidecode diff-so-fancy \
        gparted jq
    #install_pkgs --aur shc
}

