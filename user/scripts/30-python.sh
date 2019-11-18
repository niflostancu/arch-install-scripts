#!/bin/bash
# 

function do_configure() {
    pip install --user pycodestyle pyflakes vim-vint proselint yamllint pylint pylint-venv
    pip2 install --user pycodestyle vim-vint proselint yamllint
}

