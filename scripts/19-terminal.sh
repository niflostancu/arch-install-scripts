#!/bin/bash
#
# Installs fancy terminal tools

function do_install_prerequisites() {
    # terminal emulators & shells
    install_pkgs alacritty ghostty zsh tmux powerline-fonts
    # vim, GUI + integration tools
    install_pkgs neovim neovide python-pynvim wl-clipboard
    # finders
    install_pkgs ripgrep fzf the_silver_searcher 
    # misc tools
    install_pkgs ctags direnv jq yq
}

function do_configure() {
    # Change ZSH config path globally to use XDG specification
    echo 'ZDOTDIR="$HOME/.config/zsh"' > /etc/zsh/zshenv
    # change root's shell
    chsh -s /usr/bin/zsh

    true
}

