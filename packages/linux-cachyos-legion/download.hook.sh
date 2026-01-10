#!/bin/bash
# Download linux + Lenono Legion laptop patch sources

[[ -d "$PKG_BUILD_DEST/linux-cachyos/.git" ]] || \
	git clone "https://github.com/CachyOS/linux-cachyos.git" "$PKG_BUILD_DEST/linux-cachyos"
[[ -d "$PKG_BUILD_DEST/laptop-patches" ]] || \
	git clone "https://github.com/nadimkobeissi/16iax10h-linux-sound-saga.git" "$PKG_BUILD_DEST/laptop-patches"

