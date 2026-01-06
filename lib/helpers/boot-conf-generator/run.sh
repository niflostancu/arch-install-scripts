#!/bin/bash
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"

make -C "$SCRIPT_DIR" -f Makefile.bootgen.mk "$@"
