#!/usr/bin/env bash
# Path to your oh-my-zsh installation.
export ZSH="/Users/heckfer/.oh-my-zsh"

ZSH_THEME="dracula"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting)

source $ZSH/oh-my-zsh.sh

# User configuration

# ASDF
. $HOME/.asdf/asdf.sh
. $HOME/.asdf/completions/asdf.bash
# . ~/.asdf/plugins/java/asdf-java-wrapper.zsh

# My random bin
export PATH=$PATH:~/.local/bin
export PATH=$PATH:/Users/heckfer/.config/yarn/global/node_modules/.bin
export PATH="/usr/local/sbin:$PATH"

# Android
export ANDROID_HOME=~/Library/Android/sdk
export NDK_HOME=$ANDROID_HOME/ndk-bundle
export PATH=$PATH:$NDK_HOME
export PATH=$PATH:$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools

# Aliases
alias cg="cd ~/projects/campgladiator"
alias deepx="cd ~/projects/deepx"
alias heckfer="cd ~/projects/heckfer"
alias tiger="cd ~/projects/tigerhood"
alias projets="cd ~/projects"
alias reload="source ~/.zshrc"

# For compilers to find zlib you may need to set:
export LDFLAGS="${LDFLAGS} -L/usr/local/opt/zlib/lib"
export CPPFLAGS="${CPPFLAGS} -I/usr/local/opt/zlib/include"

# For pkg-config to find zlib you may need to set:
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

# Spaceship

# Helper Functions

unzip() {
  input=${1}
  output_folder=${2:-subtitles}

  case ${#} in
    1)
      echo "input - ${input}"
      echo "output folder - ${output_folder}"
      7z x -o${output_folder} ${input}
      echo "deleting ${input}"
      rm ${input}
    ;;
    2)
      echo "input - ${input}"
      echo "output folder - ${output_folder}"
      7z x -o${output_folder} ${input}
      echo "deleting ${input}"
      rm ${input}
    ;;
    *)
      echo "You passed ${#} arguments, what are you trying?"
    ;;
  esac
}

function heckshot() {
    FILENAME=$1
    FILENAME="${FILENAME:-screenshot}"
    adb shell screencap -p /sdcard/$FILENAME.png
    adb pull /sdcard/$FILENAME.png $2
    adb shell rm /sdcard/$FILENAME.png
}

function format() {
  git diff --name-only | grep -e '\(.*\).swift$' | while read line; do
    swiftformat $line;
    # git add $line;
  done
}

function pair() {
  ip_or_hostname=$1
  if grep "^[a-zA-Z]" <<(echo $ip_or_hostname); then
    ip_or_hostname=${ip_or_hostname}.lan
  fi
  open vnc://$ip_or_hostname
}

function clean_phone() {
  echo $1 | tr -d -c 0-9
}
