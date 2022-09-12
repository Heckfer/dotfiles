#!/usr/bin/env bash

# My random bin
export PATH="$PATH":~/.local/bin
export PATH="/usr/local/sbin:$PATH"

# Android
export ANDROID_HOME=~/Library/Android/sdk
export NDK_HOME="$ANDROID_HOME/ndk"
export PATH="$PATH":"$NDK_HOME"
export PATH="$PATH":"$ANDROID_HOME"
export PATH="$PATH":"$ANDROID_HOME/platform-tools"
export PATH="$PATH":"$ANDROID_HOME/emulator"


# Flutter
export FLUTTER_HOME="/Users/fheck/.asdf/installs/flutter/3.0.5-stable"
export PATH="$PATH":"$FLUTTER_HOME/bin"
export PATH="$PATH":"$FLUTTER_HOME/.pub-cache/bin"

# Google Cloud
export GCP_HOME="/Users/fheck/google-cloud-sdk"
export PATH="$PATH":"$GCP_HOME/bin"