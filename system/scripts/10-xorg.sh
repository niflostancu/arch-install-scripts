#!/bin/bash
#
# Installs Xorg, mesa & graphics drivers

function do_install_prerequisites() {
    install_pkgs xorg-server xorg-apps xorg-xrandr xorg-xinput xbindkeys
    install_pkgs nvidia-dkms libglvnd nvidia-utils nvidia-settings read-edid
    install_pkgs mesa mesa-demos xf86-video-intel bumblebee primus
}

