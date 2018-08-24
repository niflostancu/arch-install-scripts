#!/bin/bash
# 

function do_configure() {
    mkdir -p ~/.cache/nodejs
    mkdir -p ~/.cache/yarnjs
    yarn config set prefix ~/.cache/yarnjs
    npm config set prefix ~/.cache/nodejs

    yarn global add \
        bower gulp grunt-cli polymer-cli web-component-tester eslint \
        jshint jsonlint stylelint markdownlint-cli sass-lint jsxhint \
        write-good raml-cop
}

