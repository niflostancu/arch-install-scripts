#!/bin/bash

cd "$PKG_BUILD_DEST/linux-cachyos/linux-cachyos"

build_configure
makepkg -S "${MAKEPKG_ARGS[@]}"
sed -i 's|^\s*_pkgsuffix=cachyos|_pkgsuffix=cachyos-legion|g' PKGBUILD

LEGION_PATCH_NAME="16iax10h-audio-linux-6.18.patch"
LEGION_PATCH_SRC="$PKG_BUILD_DEST/laptop-patches/fix/patches/$LEGION_PATCH_NAME"
cp -f "$LEGION_PATCH_SRC" ./
sed -i '/^prepare()/i source+=("'"$LEGION_PATCH_NAME"'")' PKGBUILD
echo "b2sums+=('$(b2sum "$LEGION_PATCH_NAME"| cut -d" " -f1)')" >> PKGBUILD

cat "$PKG_BUILD_DEST/legion-extra.config" >> config
echo "b2sums[1]='$(b2sum "config"| cut -d" " -f1)'" >> PKGBUILD

cat PKGBUILD
