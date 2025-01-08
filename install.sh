#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset


echo "== Install =="
echo "- Docker - https://download.docker.com/mac/stable/Docker.dmg"
echo "- 1Password - https://c.1password.com/dist/1P/mac4"
echo "- Datagrip - https://download-cf.jetbrains.com/datagrip"
echo "- Sublime - https://download.sublimetext.com"
echo "- VSCode"
echo "- Android Studio"
echo "- Chrome"
echo "- VLC"
echo "- oh-my-zsh"
echo "- ASDF"
echo "- Homebrew"

echo "== Configuration =="
echo "- Add sublime to path - ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime"
echo "- Sublime plugins (MarkdownPreview, Pretty JSON)"
echo "- VSCode plugins (code spell checker, docker, editorconfig for vs code, elixirls, elm, env, gitlens, php-cs-fixer, prettier, sass )"
echo "oh-my-zsh..."
echo "[ -d ~/.oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh"
echo "[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting"
echo "[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || git clone git@github.com:zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
echo "[ -d ~/.oh-my-zsh/themes/dracula.zsh-theme ] || git clone git@github.com:dracula/zsh.git ~/.oh-my-zsh/themes/dracula.zsh-theme"
echo "ASDF (java, nodejs, python, ruby, flutter)"

echo "Symlinking dotfiles..."
ln -sf $(pwd)/vim/.vimrc ~/.vimrc
ln -sf $(pwd)/git/.gitconfig ~/.gitconfig
ln -sf $(pwd)/git/.gitignore_global ~/.gitignore_global
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
ln -sf $(pwd)/zsh/.zshenv ~/.zshenv
ln -sf $(pwd)/zsh/.zprofile ~/.zprofile

chsh -s $(which zsh)
