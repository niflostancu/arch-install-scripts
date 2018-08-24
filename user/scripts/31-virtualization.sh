#!/bin/bash
# 

function do_configure() {
	mkdir -p ~/.vagrant.d/gems/2.5.1
	gem install --no-user-install --install-dir ~/.vagrant.d/gems/2.5.1 pkg-config
    vagrant plugin install vagrant-libvirt
    vagrant plugin install vagrant-winrm
    vagrant plugin install vagrant-rsync-back
    vagrant plugin install vagrant-timezone
	gem install --no-user-install --install-dir ~/.vagrant.d/gems/2.5.1 pkg-config
    vagrant plugin install vagrant-scp
}

