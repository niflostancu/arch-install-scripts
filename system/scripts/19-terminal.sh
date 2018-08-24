#!/bin/bash
#
# Installs fancy terminal tools

function do_install_prerequisites() {
    install_pkgs zsh tmux neovim python-neovim python2-neovim powerline-fonts xsel \
        the_silver_searcher screen minicom ruby fzf python-virtualenvwrapper xdotool \
        ctags

    install_yaourt_pkgs alacritty-git
}

function do_configure() {
    echo 'ZDOTDIR=$HOME/.config/zsh' > /etc/zsh/zshenv
    chsh -s /usr/bin/zsh

    true
}

