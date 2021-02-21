#!/usr/bin/env bash

# Path to your oh-my-zsh installation.
export ZSH="/Users/heckfer/.oh-my-zsh"

ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
. ~/.asdf/plugins/java/set-java-home.zsh

# For PATH setup check ~/.zshenv

# For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

# Helper Functions
source ~/.heck/.alias
source ~/.heck/.utility_functions
source ~/.heck/.cg_functions

# The next line updates PATH for the Google Cloud SDK.
if [ -f '/Users/heckfer/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/heckfer/google-cloud-sdk/path.zsh.inc'; fi

# The next line enables shell command completion for gcloud.
if [ -f '/Users/heckfer/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/heckfer/google-cloud-sdk/completion.zsh.inc'; fi

