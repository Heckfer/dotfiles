#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace

echo "configuring..."

echo "java plugin..."
asdf plugin-add java
asdf install java oracle-8.141

echo "elm plugin..."
asdf plugin-add elm https://github.com/vic/asdf-elm.git
asdf install elm 0.18.0

echo "kotlin plugin..."
asdf plugin-add kotlin https://github.com/missingcharacter/asdf-kotlin
asdf install kotlin 1.3.21

echo "python plugin..."
asdf plugin-add python https://github.com/danhper/asdf-python
asdf install python 3.7.3

echo "ruby plugin..."
asdf plugin-add ruby https://github.com/asdf-vm/asdf-ruby
asdf install ruby 2.5.3
asdf install ruby 2.6.2

echo "erlang plugin..."
asdf plugin-add erlang https://github.com/asdf-vm/asdf-erlang.git
asdf install erlang 21.3.3

echo "elixir plugin..."
asdf plugin-add elixir https://github.com/asdf-vm/asdf-elixir.git
asdf install elixir 1.7.4-otp-21
asdf install elixir 1.8.1-otp-21

echo "finished installing utilities"

echo "done, now go and install the vscode plugins and the themes..."

# https://draculatheme.com/vim/
# https://draculatheme.com/sublime/
# https://draculatheme.com/visual-studio-code/
# https://draculatheme.com/terminal/