#!/bin/bash
#
# Installs Xorg, mesa & graphics drivers


function do_install_prerequisites() {
    install_pkgs xorg-server xorg-apps xorg-xrandr xorg-xinput xbindkeys mesa \
        mesa-demos xtrlock

    if [[ -n "$INSTALL_NVIDIA_GRAPHICS" ]]; then
        install_pkgs nvidia-dkms libglvnd nvidia-utils nvidia-settings \
            nvidia-prime read-edid lib32-nvidia-utils
    fi

    if [[ -n "$INSTALL_INTEL_GRAPHICS" ]]; then
        install_pkgs xf86-video-intel
    fi
    # if [[ -n "$INSTALL_HYBRID_GRAPHICS" ]]; then
    #     install_pkgs bumblebee primus
    # fi
}

