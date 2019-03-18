#!/bin/bash
# Contains copy utility functions

# rsync call with change detection: exits with 0 if there were changes made,
# != 0 otherwise
# Syntax: idem_rsync SOURCE [OVERLAY] DESTINATION
function idem_rsync() {
    DIRS=("$@")
    if [[ "$#" -gt 2 ]]; then
        DIRS=()
        for i in $(seq 1 "$#"); do
            # if the source path exists, add it
            if [[ "$i" -eq "$#" ]] || [[ -e "${!i}" ]]; then DIRS+=("${!i}"); fi
        done
    fi
    echo "DIRS = ${DIRS[@]}"
    RSYNC_OUTPUT=$(rsync -rlptDEi "${DIRS[@]}")
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

# TODO: compare two conf files
function compare_conf() {
    comm -B -12 
}

# Idempotent file copying function:
# idem_copy_conf [OPTIONS...] SOURCE_FILES... TARGET_FILE
# When multiple source files are given, only the rightmost one that exists will
# be considered.
# The function will diff the files before overwriting the target file.
# Also accepts a "-I <ignore expr>" option for ignoring a line from the diff
# input.
function idem_copy_conf() {
    if ! diff "${DIFFARGS[@]}" "$SRC_DIR/conf/$file" "$XDG_CONFIG_HOME/"; then
        NEEDS_UPDATE=y
        break
    fi
}

