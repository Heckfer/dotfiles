#!/usr/bin/env bash

# My random bin
export PATH=$PATH:~/.local/bin
export PATH="/usr/local/sbin:$PATH"

# Android
export ANDROID_HOME=~/Library/Android/sdk
export NDK_HOME=$ANDROID_HOME/ndk-bundle
export PATH=$PATH:$NDK_HOME
export PATH=$PATH:$ANDROID_HOME
export PATH=$PATH:$ANDROID_HOME/platform-tools
export PATH=$PATH:$ANDROID_HOME/tools