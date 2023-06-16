#!/usr/bin/env bash

# My random bin
export PATH="$PATH":~/.local/bin
export PATH="/usr/local/bin:$PATH"


# Android
export ANDROID_HOME=~/Library/Android/sdk
export NDK_HOME="$ANDROID_HOME/ndk"
export PATH="$PATH":"$NDK_HOME"
export PATH="$PATH":"$ANDROID_HOME"
export PATH="$PATH":"$ANDROID_HOME/platform-tools"
export PATH="$PATH":"$ANDROID_HOME/emulator"


# Flutter
export FLUTTER_HOME="/Users/fheck/.asdf/installs/flutter/3.7.6-stable"
export PATH="$PATH":"$FLUTTER_HOME/bin"
export PATH="$PATH":"/Users/fheck/.pub-cache/bin"

# Google Cloud
export GCP_HOME="/Users/fheck/google-cloud-sdk"
export PATH="$PATH":"$GCP_HOME/bin"

# Brew
eval "$(/opt/homebrew/bin/brew shellenv)"