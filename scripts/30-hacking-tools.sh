#!/bin/bash
#
# Installs various hacker / developer tools

function do_install_prerequisites() {
    # File formats / utilities
    install_pkgs zip unzip p7zip sqlite

    # Network tools
    install_pkgs bind-tools nmap aircrack-ng traceroute wireshark-qt wol \
        lftp whois iperf iperf3 dsniff tcpdump arp-scan tftp-hpa bind-tools \
        termshark

    # System monitoring
    install_pkgs htop iotop powertop

    # Crypto / forensics
    install_pkgs ophcrack john hashcat foremost testdisk easy-rsa \
        strace

    # Misc tools
    install_pkgs gnuplot rlwrap powertop dmidecode diff-so-fancy \
        units gparted jq
    install_pkgs --aur shc
}

