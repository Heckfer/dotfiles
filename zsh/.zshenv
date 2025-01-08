#!/usr/bin/env bash

# My random bin
export PATH="$PATH:/Users/fheck/.local/bin"

# Maven
export PATH="$PATH:/Users/fheck/.local/apache-maven-3.9.6/bin"

# Android
export ANDROID_HOME="/Users/fheck/Library/Android/sdk"
export NDK_HOME="$ANDROID_HOME/ndk"
export PATH="$PATH:$NDK_HOME"
export PATH="$PATH:$ANDROID_HOME"
export PATH="$PATH:$ANDROID_HOME/platform-tools"
export PATH="$PATH:$ANDROID_HOME/emulator"

# Google Cloud
export GCP_HOME="/Users/fheck/google-cloud-sdk"
export PATH="$PATH:$GCP_HOME/bin"
