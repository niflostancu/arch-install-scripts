#!/bin/bash

set -x

NPROC=${NPROC:-$(nproc)}

IFS='' read -r -d '' MAKEPKG_CONF_EXTRA <<EOF || true
CARCH=aarch64
MAKEFLAGS="-j$NPROC ARCH=arm64 CROSS_COMPILE=aarch64-linux-gnu-"
export CROSS_COMPILE=aarch64-linux-gnu-

EOF
build_config

