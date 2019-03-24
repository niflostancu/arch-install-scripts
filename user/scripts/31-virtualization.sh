#!/bin/bash
# 

function do_configure() {
    _vagrant_plugin_install vagrant-libvirt
    _vagrant_plugin_install vagrant-winrm
    _vagrant_plugin_install vagrant-rsync-back
    _vagrant_plugin_install vagrant-timezone
    _vagrant_plugin_install vagrant-scp

    idem_rsync "$SRC_DIR/conf/vagrant.d/" "$HOME/.vagrant.d/"
}

function _vagrant_plugin_install() {
    local IS_INSTALLED=
    vagrant plugin list | grep -w "$1" >/dev/null 2>&1 && IS_INSTALLED=1
    if [[ -z "$IS_INSTALLED" ]] || [[ -n "$INSTALL_UPGRADE" ]]; then
        vagrant plugin install "$1"
    fi
}

