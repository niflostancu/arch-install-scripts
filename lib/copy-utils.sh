#!/bin/bash
# Contains copy utility functions

# rsync call with change detection: exits with 0 if there were changes made,
# != 0 otherwise
# Syntax: idem_rsync SOURCE DESTINATION
function idem_rsync() {
    RSYNC_OUTPUT=$(rsync -rlptDEi "$@")
    if [ $? -eq 0 ]; then
        if [ -n "${RSYNC_OUTPUT}" ]; then
            echo "$RSYNC_OUTPUT"
            return 0
        else
            return 2
        fi
    else
        error "rsync failed: $RSYNC_OUTPUT"
        return 1
    fi

}

