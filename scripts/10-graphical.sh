#!/bin/bash
#
# Installs Xorg, mesa & graphics drivers


function do_install_prerequisites() {
    install_pkgs xorg-server xorg-xrandr xorg-xinput xbindkeys mesa \
        mesa-demos xtrlock read-edid 

    if [[ -n "$INSTALL_NVIDIA_GRAPHICS" ]]; then
        local _NVPKG="nvidia-open-dkms"
        if [[ ! "$INSTALL_NVIDIA_GRAPHICS" =~ ^[0-9]+$ ]]; then
            _NVPKG="$INSTALL_NVIDIA_GRAPHICS"
        fi
        install_pkgs "$_NVPKG" libglvnd nvidia-utils nvidia-settings \
            lib32-nvidia-utils

        if [[ "$INSTALL_GAMING_HYBRID" == "nvidia" ]]; then 
            # bbswitch not required anymore!
            # install_pkgs bbswitch-dkms
            install_pkgs nvidia-prime
        fi
    fi

    if [[ -n "$INSTALL_INTEL_GRAPHICS" ]]; then
        install_pkgs xf86-video-intel
    fi
    if [[ -n "$INSTALL_AMD_GRAPHICS" ]]; then
        # required for sensors monitoring
        install_pkgs rocm-smi-lib
    fi
}

