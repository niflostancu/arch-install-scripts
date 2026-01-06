#!/bin/bash
# mkinitcpio-based initramfs customization, dropbear remote ssh hook etc.

INITCPIO_EMERGENCY_PASSWORD=${INITCPIO_EMERGENCY_PASSWORD:-emergency}
INITCPIO_ENABLE_DROPBEAR=${INITCPIO_ENABLE_DROPBEAR:-0}

function do_install_prerequisites() {
	install_pkgs dropbear mkinitcpio
	pacman -R dracut || true
}

function do_configure() {
	local INITCPIO_CONF_OPTS=()
	if [[ "$INITCPIO_ENABLE_DROPBEAR" == "1" ]]; then
		[ -f /etc/dropbear/dropbear_rsa_host_key ] || \
			dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key
		[ -f /etc/dropbear/dropbear_ecdsa_host_key ] || \
			dropbearkey -t ecdsa -f /etc/dropbear/dropbear_ecdsa_host_key
		[ -f /etc/dropbear/dropbear_ed25519_host_key ] || \
			dropbearkey -t ed25519 -f /etc/dropbear/dropbear_ed25519_host_key
	else
		INITCPIO_CONF_OPTS+=(--exclude="90-remote-ssh.conf")
		rm -f "/etc/mkinitcpio.conf.d/90-remote-ssh.conf"
	fi

	if [[ ! -f "/etc/shadow.initramfs" ]]; then
		echo "root:$(mkpasswd "$INITCPIO_EMERGENCY_PASSWORD"):::::::" > /etc/shadow.initramfs
		chmod 700 /etc/shadown.initramfs
	fi

    ! idem_rsync_conf --all "systemd/network.initramfs/" "/etc/systemd/network.initramfs/" || true

    ! idem_rsync_conf --all "mkinitcpio.hooks/" "/usr/lib/initcpio/" || true

    ! idem_rsync_conf --all "${INITCPIO_CONF_OPTS[@]}" "mkinitcpio.conf.d/" "/etc/mkinitcpio.conf.d/" || {
    	mkinitcpio -P
    }
}
