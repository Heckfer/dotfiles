#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset
#set -o xtrace


echo "installing..."

echo "downloading docker..."
curl https://download.docker.com/mac/stable/Docker.dmg --output ~/Downloads/Docker.dmg

echo "downloading dropbox..."
curl https://dl-web.dropbox.com/installer?build_no=79.4.143&plat=mac&tag=eJyrVipOLS7OzM-Lz0xRslIwNjA1NTCzMDI3NjAwNLA0twACMxMzM2NzQ1MLkJihibmhpWEtAKkJDbg~%40META&tag_token=AOSTYpaJOWunqm2OJDHs3dl68_zmi2pl_eJ8jWKQURHAqA  --output ~/Downloads/dropbox

echo "downloading 1password6..."
curl https://c.1password.com/dist/1P/mac4/1Password-6.8.9.pkg --output ~/Downloads/1Password-6.8.9.pkg

echo "downloading datagrip..."
curl https://download-cf.jetbrains.com/datagrip/datagrip-2019.2.2.dmg --output ~/Downloads/datagrip-2019.2.2.dmg

echo "downloading charles..."
curl https://www.charlesproxy.com/assets/release/4.2.8/charles-proxy-4.2.8.dmg --output ~/Downloads/charles-proxy-4.2.8.dmg

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