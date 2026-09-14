#!/usr/bin/env bash
set -o errexit
set -o pipefail
set -o nounset

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
EXTERNAL_DIR="$HOME/projects/external"
OMZ_DIR="$HOME/.oh-my-zsh"
DRACULA_TERMINAL_DIR="$EXTERNAL_DIR/dracula-terminal-app"
DRACULA_TERMINAL_PROFILE="Dracula"

install_xcode_command_line_tools() {
    echo "== Xcode command line tools =="

    if xcode-select -p >/dev/null 2>&1; then
        echo "- already installed ($(xcode-select -p))"
        return
    fi

    echo "- triggering the installer; accept the dialog that appears"
    xcode-select --install >/dev/null 2>&1 || true

    until xcode-select -p >/dev/null 2>&1; do
        echo "  waiting for the command line tools to finish installing..."
        sleep 30
    done

    echo "- installed; git is now available"
}

clone_if_missing() {
    local repo="$1" target="$2"

    if [[ -d "$target" ]]; then
        echo "- $(basename "$target") already present"
        return
    fi

    echo "- cloning $repo"
    git clone --depth 1 --quiet "$repo" "$target"
}

install_oh_my_zsh() {
    echo "== oh-my-zsh =="

    clone_if_missing https://github.com/ohmyzsh/ohmyzsh.git "$OMZ_DIR"
    clone_if_missing https://github.com/zsh-users/zsh-syntax-highlighting.git \
        "$OMZ_DIR/custom/plugins/zsh-syntax-highlighting"
    clone_if_missing https://github.com/zsh-users/zsh-autosuggestions.git \
        "$OMZ_DIR/custom/plugins/zsh-autosuggestions"

    # .zshrc lists this plugin as `command-time`, so the directory must be named
    # that rather than after the repo.
    clone_if_missing https://github.com/popstas/zsh-command-time.git \
        "$OMZ_DIR/custom/plugins/command-time"

    clone_if_missing https://github.com/dracula/zsh.git "$OMZ_DIR/custom/themes/dracula"
    ln -sf "$OMZ_DIR/custom/themes/dracula/dracula.zsh-theme" \
        "$OMZ_DIR/custom/themes/dracula.zsh-theme"
}

install_dracula_terminal_theme() {
    echo "== Dracula for Terminal.app =="

    mkdir -p "$EXTERNAL_DIR"
    clone_if_missing https://github.com/dracula/terminal-app.git "$DRACULA_TERMINAL_DIR"

    local profile="$DRACULA_TERMINAL_DIR/Dracula.terminal"

    if defaults read com.apple.Terminal "Window Settings" 2>/dev/null |
        grep -q "\"$DRACULA_TERMINAL_PROFILE\""; then
        echo "- profile already imported"
    else
        echo "- importing the profile into Terminal.app"
        open "$profile"
    fi

    defaults write com.apple.Terminal "Default Window Settings" -string "$DRACULA_TERMINAL_PROFILE"
    defaults write com.apple.Terminal "Startup Window Settings" -string "$DRACULA_TERMINAL_PROFILE"

    # Terminal.app holds its preferences in memory and rewrites them on quit, so
    # the two writes above are lost if this script was itself run from Terminal.
    echo "- REMINDER: quit and reopen Terminal, then check Settings > Profiles."
    echo "  If Dracula is not the default, select it and click 'Default' by hand."
}

symlink_dotfiles() {
    echo "== Symlinking dotfiles =="

    ln -sf "$DOTFILES_DIR/vim/.vimrc" ~/.vimrc
    ln -sf "$DOTFILES_DIR/git/.gitconfig" ~/.gitconfig
    ln -sf "$DOTFILES_DIR/git/.gitignore_global" ~/.gitignore_global
    ln -sf "$DOTFILES_DIR/zsh/.zshrc" ~/.zshrc
    ln -sf "$DOTFILES_DIR/zsh/.zshenv" ~/.zshenv
    ln -sf "$DOTFILES_DIR/zsh/.zprofile" ~/.zprofile

    # AI agent preferences: AGENTS.md is the single source of truth. Each tool's
    # expected file is symlinked to ~/AGENTS.md (the hub), which points at the repo.
    # bkp lives in the private repo (it encodes what is worth backing up and what
    # leaks), but installation stays here — the same arrangement as the private
    # function files .zshrc sources from there by absolute path.
    mkdir -p ~/.local/bin
    ln -sf ~/projects/heckfer/private-dotfiles/bkp ~/.local/bin/bkp

    ln -sf "$DOTFILES_DIR/ai/AGENTS.md" ~/AGENTS.md
    mkdir -p ~/.claude ~/.gemini
    ln -sf ~/AGENTS.md ~/.claude/CLAUDE.md
    ln -sf ~/AGENTS.md ~/.gemini/GEMINI.md

    chsh -s "$(which zsh)"
}

print_manual_steps() {
    cat <<'EOF'

== Install by hand (GUI apps) ==
- Docker - https://download.docker.com/mac/stable/Docker.dmg
- 1Password - https://c.1password.com/dist/1P/mac4
- Datagrip - https://download-cf.jetbrains.com/datagrip
- Sublime - https://download.sublimetext.com
- VSCode
- Android Studio
- Chrome
- VLC
- ASDF
- Homebrew

== Reminders ==
- After installing VS Code and Sublime, run ./editors/install-plugins.sh again —
  it skips whichever editor is missing, so a second pass picks up the rest.
- Claude Code skills: claude plugins install mattpocock-skills
  (https://github.com/mattpocock/skills)
- Run ./configure.sh for the ASDF language plugins (java, nodejs, python, ruby, flutter)
- Run ./macos/set-defaults.sh (trackpad, Dock, Finder, Spotlight, dark mode, ...),
  then log out and back in; see macos/README.md for what must be set by hand
- `bkp restore claude` puts back Claude Code transcripts and memories
- `bkp restore sublime` puts back the editor session (quit Sublime first)
- `bkp backup` takes a fresh snapshot of all three targets
- bkp and its docs live in ~/projects/heckfer/private-dotfiles
EOF
}

install_xcode_command_line_tools
install_oh_my_zsh
install_dracula_terminal_theme
symlink_dotfiles
"$DOTFILES_DIR/editors/install-plugins.sh"
print_manual_steps
