#!/bin/bash
# 

function do_configure() {
    local CONF_FILES=(dolphinrc konsolerc alacritty)
    local DATA_FILES=(konsole)

    idem_rsync "${CONF_FILES[@]/#/$SRC_DIR/conf/}" "$XDG_CONFIG_HOME/"
    idem_rsync "${DATA_FILES[@]/#/$SRC_DIR/conf/share/}" "$XDG_DATA_HOME/"

    true
}

