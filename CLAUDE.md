# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## What this is

Personal macOS dotfiles for Fernando Heck. There is no build, test, or lint step — changes are shell/config files that take effect once symlinked into `$HOME`. `CLAUDE.md`, `.claude/`, and `GEMINI.md` are intentionally gitignored (see `git/.gitignore_global`).

## How it's wired together

Config files live under topic directories (`zsh/`, `git/`, `vim/`, `sh/`, `ai/`) and are **symlinked** into `$HOME` by `install.sh` (`ln -sf`). Editing a file here edits the live config directly — no copy step. To register a new dotfile, add both the file and an `ln -sf` line in `install.sh`.

`ai/AGENTS.md` is the single source of truth for cross-tool AI agent preferences. The symlinks form a **hub**: `~/AGENTS.md` → `ai/AGENTS.md`, and each tool's expected file points at the hub — `~/.claude/CLAUDE.md` → `~/AGENTS.md` and `~/.gemini/GEMINI.md` → `~/AGENTS.md`. So every agent reads identical content; edit `ai/AGENTS.md` to change preferences for all of them.

Shell startup order on macOS zsh, by design:
- `zsh/.zprofile` — login shells; initializes Homebrew (`brew shellenv`).
- `zsh/.zshenv` — every shell; owns all `PATH` exports (Android SDK, GCP, Flutter/pub-cache, pnpm, Maven, `~/.local/bin`). Put new `PATH` entries here, not in `.zshrc`.
- `zsh/.zshrc` — interactive shells; oh-my-zsh + plugins, `EDITOR`, ASDF init, and sourcing of utility/alias files.

`.zshrc` sources three function files, two of which are **outside this repo** and must exist for the shell to load cleanly:
- `~/projects/heckfer/private-dotfiles/.aliases`
- `~/projects/heckfer/private-dotfiles/.wendys-functions`
- `sh/.utility_functions` (in this repo)

## Runtime & package management

- **ASDF** manages language versions (java, kotlin, python, ruby, erlang, elixir). `configure.sh` is a one-time bootstrap that only registers the ASDF plugins (`asdf plugin add`) — it does not pin or install versions, so set those per-project with `.tool-versions`.
- **Homebrew** packages are in `Brewfile` (`brew bundle` to install). It's mostly CLI helpers (`bat`, `fd`, `jq`, `ag`, `shellcheck`, `diff-so-fancy`) plus the compile-time deps ASDF needs to build ruby/python.
- `install.sh` itself is largely `echo`'d manual instructions (GUI apps, oh-my-zsh, plugin clones) followed by the real symlinking + `chsh`. Read its output rather than expecting it to fully automate setup.

## Conventions

- Shell scripts use `set -o errexit -o pipefail -o nounset`. Keep this on new scripts.
- The `git cs` alias auto-prefixes commits with a task id parsed from the branch name (text before the first `/`). Branch names are expected to look like `TASK-123/description`.
- Indentation is 4 spaces (`.vimrc`, git config).
- `keyboard/` stores exported Keychron K12 Pro keymap JSON — data, not config that's loaded by anything.
