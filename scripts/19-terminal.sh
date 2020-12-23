#!/bin/bash
#
# Installs fancy terminal tools

function do_install_prerequisites() {
    install_pkgs zsh tmux neovim python-pynvim powerline-fonts xsel \
        the_silver_searcher screen minicom ruby fzf python-virtualenvwrapper xdotool \
        ctags alacritty

    # install_aur_pkgs alacritty-git
}

function do_configure() {
    # Change ZSH config path globally to use XDG
    echo 'ZDOTDIR=$HOME/.config/zsh' > /etc/zsh/zshenv
    # change root's shell
    chsh -s /usr/bin/zsh

    true
}

