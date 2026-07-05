# ZSH
export ZSH="/Users/fheck/.oh-my-zsh"
ZSH_THEME="robbyrussell"

plugins=(git zsh-autosuggestions zsh-syntax-highlighting command-time)

source $ZSH/oh-my-zsh.sh

export EDITOR="/usr/bin/vim"

USER_NAME="fheck"

# JAVA_HOME
source /Users/$USER_NAME/.asdf/plugins/java/set-java-home.zsh

# For pkg-config to find zlib
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

# Helper Functions
source /Users/$USER_NAME/projects/heckfer/private-dotfiles/.aliases
source /Users/$USER_NAME/projects/heckfer/private-dotfiles/.wendys-functions
source /Users/$USER_NAME/projects/heckfer/dotfiles/sh/.utility_functions

# Google Cloud SDK PATH and AutoComplete Setup.
if [ -f "/Users/$USER_NAME/google-cloud-sdk/path.zsh.inc" ]; then . "/Users/$USER_NAME/google-cloud-sdk/path.zsh.inc"; fi
if [ -f "/Users/$USER_NAME/google-cloud-sdk/completion.zsh.inc" ]; then . "/Users/$USER_NAME/google-cloud-sdk/completion.zsh.inc"; fi

## Dart Completion scripts setup.
if [ -f "/Users/$USER_NAME/.dart-cli-completion/zsh-config.zsh" ]; then . "/Users/$USER_NAME/.dart-cli-completion/zsh-config.zsh"; fi
