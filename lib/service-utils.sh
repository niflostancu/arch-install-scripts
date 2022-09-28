#!/bin/bash
# Service wrappers / utility functions

# systemctl with dry run feature
function systemctl() {
    local -a SYSTEMCTL_ARGS=()
    [[ -z "$DRY_RUN" ]] || SYSTEMCTL_ARGS+=(--dry-run)
    command systemctl "${SYSTEMCTL_ARGS[@]}" "$@"
}

