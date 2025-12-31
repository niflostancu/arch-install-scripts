#!/bin/bash
# mkinitcpio-based initramfs customization, dropbear remote ssh hook etc.

INITCPIO_EMERGENCY_PASSWORD=${INITCPIO_EMERGENCY_PASSWORD:-emergency}

function do_install_prerequisites() {
	install_pkgs mkinitcpio
}

function do_configure() {

	if [[ ! -f "/etc/shadow.initramfs" ]]; then
		echo "root:$(mkpasswd "$INITCPIO_EMERGENCY_PASSWORD"):::::::" > /etc/shadow.initramfs
		chmod 700 /etc/shadown.initramfs
	fi

    ! idem_rsync_conf --all "mkinitcpio.hooks/" "/usr/lib/initcpio/" || true

    ! idem_rsync_conf --all "mkinitcpio.conf.d/" "/etc/mkinitcpio.conf.d/" || {
    	mkinitcpio -P
    }
}
