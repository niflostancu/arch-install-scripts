#!/bin/bash
#
# Installs fancy terminal tools

function do_install_prerequisites() {
    install_pkgs zsh tmux neovim python-pynvim powerline-fonts xsel \
        the_silver_searcher minicom ruby fzf python-virtualenvwrapper xdotool \
        ctags alacritty ripgrep
    # Neovim client in rust
    install_pkgs neovide
}

function do_configure() {
    # Change ZSH config path globally to use XDG specification
    echo 'ZDOTDIR="$HOME/.config/zsh"' > /etc/zsh/zshenv
    # change root's shell
    chsh -s /usr/bin/zsh

    true
}

