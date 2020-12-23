#!/bin/bash
#
# Installs NetworkManager & other essential networking tools

function do_install_prerequisites() {
    # NM / MM
    install_pkgs networkmanager modemmanager mobile-broadband-provider-info

    # Security / VPNs
    install_pkgs networkmanager-pptp networkmanager-openvpn \
        dnscrypt-proxy wireguard-dkms wireguard-tools \
        openconnect networkmanager-openconnect 

    # Other network related requisites
    install_pkgs ebtables bridge-utils openbsd-netcat dnsmasq
}

function do_configure() {
    systemctl enable NetworkManager

    # Set up dnscrypt
    systemctl enable dnscrypt-proxy.service
    systemctl disable dnscrypt-proxy.socket
    if idem_rsync "$SRC_DIR/etc/dnscrypt-proxy/" "/etc/dnscrypt-proxy/"; then
        echo "DNSCrypt config installed"
        systemctl stop dnscrypt-proxy.socket
        systemctl restart dnscrypt-proxy.service
    fi

    if ! grep -Eq 'nameserver\s+127.0.0.1$' /etc/resolv.conf; then
        echo "Installing dnscrypt as nameserver..."
        sed -i -e '$anameserver 127.0.0.1' -e '/nameserver/d' /etc/resolv.conf
    fi

    if idem_rsync "$SRC_DIR/etc/NetworkManager/" "/etc/NetworkManager/"; then
        echo "NetworkManager config installed"
        systemctl restart NetworkManager
    fi

    idem_rsync "$SRC_DIR/etc/nsswitch.conf" "/etc/nsswitch.conf"
    idem_rsync "$SRC_DIR/etc/dnsmasq.conf" "/etc/dnsmasq.conf"

    true
}

