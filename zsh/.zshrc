#!/usr/bin/env bash

# Path to your oh-my-zsh installation.
export ZSH="/Users/fheck/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting asdf command-time)

source $ZSH/oh-my-zsh.sh

# User configuration

export EDITOR="/usr/bin/vim"

# ASDF
. ~/.asdf/plugins/java/set-java-home.zsh

# For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

# Helper Functions
source ~/.heck/.alias
source ~/.heck/.utility_functions
