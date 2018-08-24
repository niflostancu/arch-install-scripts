#!/bin/bash
# 

function do_configure() {
    local KFILES=(kwinrc kwinrulesrc breezerc)
    local PFILES=(kdeglobals)
    local NEEDS_UPDATE=
    local DIFFARGS=(-q --strip-trailing-cr)

    for file in $KFILES; do
        if ! diff "${DIFFARGS[@]}" "$SRC_DIR/conf/$file" "$XDG_CONFIG_HOME/"; then
            NEEDS_UPDATE=y
            break
        fi
    done

    if [[ -n "$NEEDS_UPDATE" ]]; then
        information "Note: killing kwin..."
        killall kwin_x11
        sleep 1

        idem_rsync "${KFILES[@]/#/"$SRC_DIR/conf/"}" "$XDG_CONFIG_HOME/"
        idem_rsync "${PFILES[@]/#/"$SRC_DIR/conf.$PROFILE/"}" "$XDG_CONFIG_HOME/"

        information "Restarting kwin..."
        sleep 1
        nohup kwin_x11 --replace >/dev/null 2>&1 &
    fi

    true
}

