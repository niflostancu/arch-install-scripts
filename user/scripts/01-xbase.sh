#!/bin/bash
# Profile configuration

function do_configure() {
    # Change user shell
    if [[ "$SHELL" != "/usr/bin/zsh" ]]; then
        chsh -s /usr/bin/zsh
    fi

    # Copy the X profile
    if [[ -f "$SRC_DIR/conf/xprofile" ]]; then
        idem_rsync "$SRC_DIR/conf.$PROFILE/xprofile" "$XDG_CONFIG_HOME/xprofile"
    fi
    if [[ ! -f ~/.xprofile ]]; then
        ln -s "$XDG_CONFIG_HOME/xprofile" ~/.xprofile
    fi

    # Fonts, font config
    local CONF_FILES=(fontconfig)
    local DATA_FILES=(fonts)

    idem_rsync "${CONF_FILES[@]/#/$SRC_DIR/conf/}" "$XDG_CONFIG_HOME/"
    idem_rsync "${DATA_FILES[@]/#/$SRC_DIR/conf/share/}" "$XDG_DATA_HOME/"

    true
}

