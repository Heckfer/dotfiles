#!/usr/bin/env bash

echo "installing..."


echo "downloading sublime..."
curl https://download.sublimetext.com/Sublime%20Text%20Build%203207.dmg --output ~/Downloads/sublime.dmg

echo "add sublime to path..."
ln -s /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl /usr/local/bin/sublime

echo "downloading vscode..."
curl https://az764295.vo.msecnd.net/stable/f06011ac164ae4dc8e753a3fe7f9549844d15e35/VSCode-darwin-stable.zip --output ~/Downloads/VSCode-darwin-stable.zip

echo "downloading android studio..."
curl https://dl.google.com/dl/android/studio/install/3.4.2.0/android-studio-ide-183.5692245-mac.dmg --output ~/Downloads/android-studio-ide-183.5692245-mac.dmg

echo "downloading chrome..."
curl https://dl.google.com/chrome/mac/stable/GGRO/googlechrome.dmg --output ~/Downloads/googlechrome.dmg

echo "downloading vlc"
curl https://espejito.fder.edu.uy/videolan/vlc/3.0.7.1/macosx/vlc-3.0.7.1.dmg --output ~/Downloads/vlc-3.0.7.1.dmg

echo "installing oh-my-zsh..."
[ -d ~/.oh-my-zsh ] || git clone https://github.com/robbyrussell/oh-my-zsh.git ~/.oh-my-zsh
[ -d ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting ] || git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.oh-my-zsh/custom/plugins/zsh-syntax-highlighting
[ -d ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions ] || git clone git@github.com:zsh-users/zsh-autosuggestions.git ~/.oh-my-zsh/custom/plugins/zsh-autosuggestions
[ -d ~/.oh-my-zsh/themes/dracula.zsh-theme ] || git clone git@github.com:dracula/zsh.git ~/.oh-my-zsh/themes/dracula.zsh-theme
echo "oh-my-zsh installed"

echo "installing asdf..."
[ -d ~/.asdf ] || git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.7.4
echo "asdf installed"

echo "installing homebrew..."
[ ! -f "`which brew`" ] && /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
echo "homebrew installed"

echo "symlinking dotfiles..."
ln -sf $(pwd)/vim/.vimrc ~/.vimrc
ln -sf $(pwd)/git/.gitconfig ~/.gitconfig
ln -sf $(pwd)/git/.gitignore_global ~/.gitignore_global
ln -sf $(pwd)/zsh/.zshrc ~/.zshrc
echo "files symlinked"

chsh -s $(which zsh)