#!/bin/bash
# Installs Multimedia apps

function do_install_prerequisites() {
    install_pkgs vlc gstreamer gst-plugins-good gst-plugins-ugly phonon-qt5-gstreamer gst-libav \
        phonon-qt5-vlc lame cdrtools cdrdao dvd+rw-tools k3b digikam cantata mpd pipewire \
        pipewire-pulse gwenview kamera kcolorchooser kdegraphics-thumbnailers \
        kolourpaint kruler okular skanlite spectacle svgpart
    # Image manipulation
    install_pkgs gimp imagemagick inkscape dia
    # Music / video editing / conversion
    install_pkgs ffmpeg youtube-dl kid3 avidemux-qt
}

