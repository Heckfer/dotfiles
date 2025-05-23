# ZSH
export ZSH="/Users/fheck/.oh-my-zsh"
ZSH_THEME="robbyrussell"
plugins=(git zsh-autosuggestions zsh-syntax-highlighting command-time)
source $ZSH/oh-my-zsh.sh

export EDITOR="/usr/bin/vim"

# ASDF
. "$HOME/.asdf/asdf.sh"
. /Users/fheck/.asdf/plugins/java/set-java-home.zsh

# For pkg-config to find zlib
export PKG_CONFIG_PATH="${PKG_CONFIG_PATH} /usr/local/opt/zlib/lib/pkgconfig"

# Helper Functions
source /Users/fheck/projects/heckfer/private-dotfiles/.aliases
source /Users/fheck/projects/heckfer/private-dotfiles/.wendys-functions
source /Users/fheck/projects/heckfer/dotfiles/sh/.utility_functions

# Google Cloud SDK PATH and AutoComplete Setup.
if [ -f '/Users/fheck/google-cloud-sdk/path.zsh.inc' ]; then . '/Users/fheck/google-cloud-sdk/path.zsh.inc'; fi
if [ -f '/Users/fheck/google-cloud-sdk/completion.zsh.inc' ]; then . '/Users/fheck/google-cloud-sdk/completion.zsh.inc'; fi

## [Completion]
## Completion scripts setup. Remove the following line to uninstall
[[ -f /Users/fheck/.dart-cli-completion/zsh-config.zsh ]] && . /Users/fheck/.dart-cli-completion/zsh-config.zsh || true
## [/Completion]
