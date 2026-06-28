#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

echo "configuring..."

echo "java plugin..."
asdf plugin add java

echo "kotlin plugin..."
asdf plugin add kotlin

echo "python plugin..."
asdf plugin add python

echo "ruby plugin..."
asdf plugin add ruby

echo "erlang plugin..."
asdf plugin add erlang

echo "elixir plugin..."
asdf plugin add elixir

echo "finished installing utilities"

echo "done, now go and install the vscode plugins and the themes..."

# https://draculatheme.com/vim/
# https://draculatheme.com/sublime/
# https://draculatheme.com/visual-studio-code/
# https://draculatheme.com/terminal/
