#!/usr/bin/env bash
#
# Installs editor plugins for the editors that are already on this machine.
# VS Code and Sublime Text themselves must be installed by hand first; this
# script skips whichever one it cannot find, so it is safe to re-run after
# installing the second editor.

set -o errexit
set -o pipefail
set -o nounset

DOTFILES_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
VSCODE_EXTENSIONS="$DOTFILES_DIR/editors/vscode-extensions.txt"
SUBLIME_PACKAGE_CONTROL="$DOTFILES_DIR/editors/sublime/Package Control.sublime-settings"
SUBLIME_USER_DIR="$HOME/Library/Application Support/Sublime Text/Packages/User"
SUBLIME_BIN="/Applications/Sublime Text.app/Contents/SharedSupport/bin/subl"
# ~/.local/bin is on PATH via .zshenv and needs no sudo, unlike /usr/local/bin.
LOCAL_BIN="$HOME/.local/bin"

install_vscode_extensions() {
    if ! command -v code >/dev/null 2>&1; then
        echo "  VS Code: \`code\` not on PATH — skipping."
        echo "    Install VS Code, then run its 'Shell Command: Install \`code\` command in PATH'"
        echo "    from the command palette and re-run this script."
        return
    fi

    local installed extension
    installed="$(code --list-extensions | tr '[:upper:]' '[:lower:]')"

    while read -r extension; do
        [[ -z "$extension" || "$extension" == \#* ]] && continue
        if grep -qxF "$(echo "$extension" | tr '[:upper:]' '[:lower:]')" <<<"$installed"; then
            echo "  VS Code: $extension already installed"
        else
            echo "  VS Code: installing $extension"
            code --install-extension "$extension" --force >/dev/null
        fi
    done <"$VSCODE_EXTENSIONS"
}

link_sublime_packages() {
    if [[ ! -x "$SUBLIME_BIN" ]]; then
        echo "  Sublime Text: not installed — skipping."
        return
    fi

    mkdir -p "$LOCAL_BIN"
    ln -sf "$SUBLIME_BIN" "$LOCAL_BIN/sublime"

    if [[ ! -d "$SUBLIME_USER_DIR" ]]; then
        echo "  Sublime Text: installed but never launched — start it once, then re-run this script."
        return
    fi

    ln -sf "$SUBLIME_PACKAGE_CONTROL" "$SUBLIME_USER_DIR/Package Control.sublime-settings"
    echo "  Sublime Text: package list linked."
    echo "    Install Package Control (Command Palette > 'Install Package Control') if you"
    echo "    have not yet; it reads that file on the next launch and installs the rest."
}

echo "== Editor plugins =="
install_vscode_extensions
link_sublime_packages
