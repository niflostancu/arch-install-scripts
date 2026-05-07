#!/bin/bash
# Download linux + Lenono Legion laptop patch sources

[[ -d "$PKG_BUILD_DEST/linux-cachyos/.git" ]] || {
	git clone $LINUX_CACHYOS_GIT_ARGS "https://github.com/CachyOS/linux-cachyos.git" "$PKG_BUILD_DEST/linux-cachyos"
	( cd "$PKG_BUILD_DEST/linux-cachyos"; git checkout 1c6414d )
}
[[ -d "$PKG_BUILD_DEST/laptop-patches" ]] || \
	git clone "https://github.com/marco-giunta/legion-pro7-gen10-audio.git" "$PKG_BUILD_DEST/laptop-patches"

