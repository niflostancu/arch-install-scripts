#!/bin/bash
set -e

SRC_DIR="$(dirname -- "${BASH_SOURCE[0]}")/../../../"

SOUND_PATCHES=$HOME/.cache/arch-build/linux-cachyos-legion/laptop-patches
ALSA_UCM2_ANALOG="$SRC_DIR/packages/linux-cachyos-legion/ucm2-patched/HiFi-analog.conf"
#ALSA_UCM2_ANALOG="$SOUND_PATCHES/fix/ucm2/HiFi-analog.conf"

# copy firmware
sudo cp -f "$SOUND_PATCHES/fix/firmware/aw88399_acf.bin" /lib/firmware/aw88399_acf.bin

# copy Alsa UCM2 topologies
sudo cp -f "$ALSA_UCM2_ANALOG" /usr/share/alsa/ucm2/HDA/HiFi-analog.conf
# not present anymore
#sudo cp -f "$SOUND_PATCHES/fix/ucm2/HiFi-mic.conf" /usr/share/alsa/ucm2/HDA/HiFi-mic.conf

HW_ID=${1:-1}

alsaucm -c hw:$HW_ID reset
alsaucm -c hw:$HW_ID reload

mkdir -p ~/.config/wireplumber/wireplumber.conf.d/
cat << EOF > ~/.config/wireplumber/wireplumber.conf.d/51-legion-speaker-volume.conf
monitor.alsa.rules = [
  {
    matches = [
      { node.name = "alsa_output.pci-0000_80_1f.3-platform-skl_hda_dsp_generic.HiFi__Speaker__sink" }
    ]
    actions = {
      update-props = { api.alsa.soft-mixer = true }
    }
  }
]
EOF

systemctl --user restart pipewire pipewire-pulse wireplumber

amixer -c $HW_ID set Master 100%
amixer -c $HW_ID set Speaker 100%
amixer -c $HW_ID sset Headphone 100%
amixer -c $HW_ID cset numid=39 45,45  # Pre Mixer
amixer -c $HW_ID cset numid=40 45,45  # Post Mixer
amixer -c $HW_ID cset numid=51 45,45  # Deepbuffer

