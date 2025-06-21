#!/bin/bash

sh_log_info "Patching electron dependency..."

# replace old electron dependency
sed -i 's/electron29/electron34/g' PKGBUILD

