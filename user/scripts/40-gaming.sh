#!/bin/bash
# 

function do_configure() {
	idem_rsync "$SRC_DIR/conf/nvidia-xinitrc" "$HOME/.nvidia-xinitrc"
}

