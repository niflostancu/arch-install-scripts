#!/bin/bash
#
# Installs NetworkManager & other essential networking tools

function do_install_prerequisites() {
    # NM / MM
    install_pkgs networkmanager modemmanager mobile-broadband-provider-info

    # Security / VPNs
    install_pkgs networkmanager-pptp networkmanager-openvpn \
        dnscrypt-proxy wireguard-tools \
        openconnect networkmanager-openconnect 

    # Other network related requisites
    install_pkgs bridge-utils openbsd-netcat dnsmasq
}

function do_configure() {
    systemctl enable NetworkManager

    # Set up dnscrypt proxy as main DNS
    systemctl enable dnscrypt-proxy.service
    systemctl disable dnscrypt-proxy.socket
    idem_rsync_conf --all "dnscrypt-proxy/" "/etc/dnscrypt-proxy/"
    local _EXCODE=$?
    if [[ "$_EXCODE" -eq 0 ]]; then
        echo "DNSCrypt config installed"
        systemctl stop dnscrypt-proxy.socket
        systemctl restart dnscrypt-proxy.service
    fi
    if ! grep -Eq 'nameserver\s+127.0.0.1$' /etc/resolv.conf; then
        echo "Installing dnscrypt as nameserver..."
        sed -i -e '$anameserver 127.0.0.1' -e '/nameserver/d' /etc/resolv.conf
    fi

    if idem_rsync_conf --all "NetworkManager/" "/etc/NetworkManager/"; then
        echo "NetworkManager config installed"
        systemctl restart NetworkManager
    fi

    idem_rsync_conf "nsswitch.conf" "/etc/nsswitch.conf"
    idem_rsync_conf "dnsmasq.conf" "/etc/dnsmasq.conf"

    true
}

