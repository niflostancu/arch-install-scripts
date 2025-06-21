#!/bin/bash
# Installs Multimedia apps

function do_install_prerequisites() {
    install_pkgs vlc gstreamer gst-plugins-good gst-plugins-ugly gst-libav \
        lame cdrtools cdrdao dvd+rw-tools k3b digikam mpd pipewire \
        pipewire-pulse gwenview kamera kcolorchooser kdegraphics-thumbnailers \
        kolourpaint kruler okular skanlite spectacle svgpart
    # Image manipulation
    install_pkgs gimp imagemagick inkscape
    # Music / video editing / conversion
    install_pkgs ffmpeg kid3 avidemux-qt
    install_pkgs --aur youtube-dl
}

