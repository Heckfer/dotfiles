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
echo "- VSCode plugins (code spell checker, docker, editorconfig for vs code, gitlens, prettier)"
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

# AI agent preferences: AGENTS.md is the single source of truth. Each tool's
# expected file is symlinked to ~/AGENTS.md (the hub), which points at the repo.
# bkp lives in the private repo (it encodes what is worth backing up and what
# leaks), but installation stays here — the same arrangement as the private
# function files .zshrc sources from there by absolute path.
mkdir -p ~/.local/bin
ln -sf ~/projects/heckfer/private-dotfiles/bkp ~/.local/bin/bkp

ln -sf $(pwd)/ai/AGENTS.md ~/AGENTS.md
mkdir -p ~/.claude ~/.gemini
ln -sf ~/AGENTS.md ~/.claude/CLAUDE.md
ln -sf ~/AGENTS.md ~/.gemini/GEMINI.md

chsh -s $(which zsh)

echo "== macOS system preferences =="
echo "- Run ./macos/set-defaults.sh (trackpad, Dock, Finder, Spotlight, dark mode, ...)"
echo "- Then log out and back in, and see macos/README.md for what must be set by hand"
echo "- \`bkp restore claude\` puts back Claude Code transcripts and memories"
echo "- \`bkp restore sublime\` puts back the editor session (quit Sublime first)"
echo "- \`bkp backup\` takes a fresh snapshot of all three targets"
echo "- bkp and its docs live in ~/projects/heckfer/private-dotfiles"
