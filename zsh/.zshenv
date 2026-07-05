#!/usr/bin/env bash

USER_NAME="fheck"

# ASDF
export ASDF_DATA_DIR="/Users/$USER_NAME/.asdf"
export PATH="$ASDF_DATA_DIR/shims:$PATH"

# My random bin
export PATH="$PATH:/Users/$USER_NAME/.local/bin"

# Maven
export PATH="$PATH:/Users/$USER_NAME/.local/apache-maven-3.9.6/bin"

# Android
export ANDROID_HOME="/Users/$USER_NAME/Library/Android/sdk"
export NDK_HOME="$ANDROID_HOME/ndk"
export PATH="$PATH:$NDK_HOME"
export PATH="$PATH:$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Google Cloud
export GCP_HOME="/Users/$USER_NAME/google-cloud-sdk"
export PATH="$PATH:$GCP_HOME/bin"

# Flutter
export PATH="$PATH":"$HOME/.pub-cache/bin"

# pnpm
export PNPM_HOME="/Users/$USER_NAME/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME/bin:"*) ;;
  *) export PATH="$PNPM_HOME/bin:$PATH" ;;
esac

# antigravity
export PATH="/Users/$USER_NAME/.local/bin:$PATH"
