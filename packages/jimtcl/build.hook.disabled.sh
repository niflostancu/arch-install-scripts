#!/bin/bash

sh_log_info "Patching jimtcl..."

# need to disable LTO
MAKEPKG_CONF_EXTRA="OPTIONS+=(!lto)"$'\n'

build_configure
