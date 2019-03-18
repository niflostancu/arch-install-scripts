#!/bin/bash
#
# Installs Multimedia apps

function do_install_prerequisites() {
    install_pkgs clementine vlc gstreamer gst-plugins-good \
        gst-plugins-ugly phonon-qt5-gstreamer gst-libav \
        phonon-qt5-vlc lame cdrtools cdrdao dvd+rw-tools k3b digikam \
        cantata mpd
    # Image manipulation
    install_pkgs gimp imagemagick inkscape dia
    # Music / video editing / conversion
    install_pkgs ffmpeg youtube-dl kid3
}

