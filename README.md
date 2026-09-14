# dotfiles

Personal macOS setup: shell, git, vim, AI agent preferences, macOS system
preferences, and the Brewfile.

Config files live under topic directories and are **symlinked** into `$HOME` by
`install.sh`, so editing a file here edits the live config — there is no copy or
build step, and nothing to re-run after a change.

There is a private companion repo, `private-dotfiles`, holding the things that
should not be public: personal aliases, agent instructions, and `bkp` (the
backup command). Clone both side by side.

## Setting up a new machine

Order matters — each step assumes the previous one.

```sh
# 1. Both repos, as siblings. install.sh and .zshrc use these exact paths.
mkdir -p ~/projects/heckfer && cd ~/projects/heckfer
git clone git@github.com:Heckfer/dotfiles.git
git clone git@github.com:Heckfer/private-dotfiles.git

# 2. Homebrew packages (CLI helpers, plus the compile-time deps ASDF needs).
cd dotfiles && brew bundle

# 3. Symlink the dotfiles, link bkp onto PATH, set zsh as the login shell.
./install.sh

# 4. Register the ASDF language plugins.
./configure.sh

# 5. macOS system preferences, then log out and back in.
./macos/set-defaults.sh

# 6. Claude Code skills.
claude plugins install mattpocock-skills
```

Step 1 needs `git`, which on a fresh machine means macOS will pop up the Xcode
command line tools installer. Accept it; `install.sh` checks for the tools again
and triggers the same installer if it is somehow still missing.

`install.sh` installs the Xcode command line tools (so `git` works), clones
oh-my-zsh and its plugins, clones and imports the Dracula theme for Terminal.app,
symlinks the dotfiles, and runs `editors/install-plugins.sh`. It is idempotent —
re-running it is safe and is the way to pick up new entries. It finishes by
printing the GUI apps it cannot install for you plus a list of reminders;
**read that output**.

`configure.sh` only registers ASDF plugins; it pins no versions. Set those per
project with a `.tool-versions` file.

### Restoring the previous machine's state

`bkp` (from the private repo, on `PATH` after `install.sh`) puts back what a
fresh install cannot recreate:

```sh
bkp list                # what backups exist, and whether iCloud has them locally
bkp fetch               # download any that iCloud has evicted
bkp restore claude      # Claude Code transcripts, memories, prompt history
bkp restore sublime     # editor tabs and unsaved buffers (quit Sublime first)
bkp restore macos       # explains why this one is manual
```

Take a backup before handing a machine over with `bkp backup`. Full
documentation is in the private repo's `README.md`.

## What's here

| Path | Contents |
| --- | --- |
| `zsh/` | `.zprofile` (login: Homebrew), `.zshenv` (all `PATH` exports), `.zshrc` (interactive: oh-my-zsh, plugins, ASDF) |
| `git/` | `.gitconfig` and `.gitignore_global` |
| `vim/` | `.vimrc` |
| `sh/` | `.utility_functions` — small helpers sourced into every interactive shell |
| `ai/` | `AGENTS.md`, the single source of truth for AI agent preferences |
| `macos/` | `set-defaults.sh` and its notes — see `macos/README.md` |
| `editors/` | VS Code extension list, Sublime package list, and `install-plugins.sh` which applies both |
| `keyboard/` | Exported Keychron K12 Pro keymap. Data for the QMK/VIA configurator, not loaded by anything here |
| `Brewfile` | `brew bundle` installs it |

### Shell startup order

- `.zprofile` — login shells only; initializes Homebrew.
- `.zshenv` — every shell; owns **all** `PATH` exports. New `PATH` entries go
  here, not in `.zshrc`.
- `.zshrc` — interactive shells; oh-my-zsh, `EDITOR`, ASDF, and the sourcing of
  the alias and function files.

`.zshrc` sources `.aliases` from `private-dotfiles` by absolute path, so that
repo must be cloned to the path above or every new shell reports a missing file.

### Editor plugins

VS Code and Sublime Text are installed by hand, so `editors/install-plugins.sh`
skips whichever one it cannot find and is meant to be re-run once they are
present. `install.sh` calls it, or run it directly.

- **VS Code** — `editors/vscode-extensions.txt` is one extension id per line,
  installed with `code --install-extension`. This needs the `code` command on
  `PATH`: in VS Code, run *Shell Command: Install `code` command in PATH* from
  the command palette. Add an extension by appending its id; get ids for what
  you already have with `code --list-extensions`.
- **Sublime Text** — `editors/sublime/Package Control.sublime-settings` is
  symlinked into Sublime's `Packages/User` directory. Package Control reads its
  `installed_packages` list on launch and installs anything missing, so adding a
  package name there is the whole job. Package Control itself must be installed
  once by hand (*Command Palette > Install Package Control*), and Sublime has to
  have been launched at least once before the `Packages/User` directory exists.
  The script also links `subl` to `~/.local/bin/sublime`, which is on `PATH` and
  needs no `sudo`.

### Themes

The Dracula theme for Terminal.app is cloned to `~/projects/external/dracula-terminal-app`
(the `external` directory is for upstream repos that are not ours; `install.sh`
creates it). `install.sh` imports the profile with `open` and points
`com.apple.Terminal`'s *Default* and *Startup Window Settings* at it. Terminal
rewrites its own preferences when it quits, so if `install.sh` was run from
Terminal those writes can be lost — quit and reopen Terminal and confirm the
profile is the default, setting it by hand if not.

### AI agent preferences

`ai/AGENTS.md` is the source of truth, and the symlinks form a hub:

    ~/AGENTS.md            -> ai/AGENTS.md
    ~/.claude/CLAUDE.md    -> ~/AGENTS.md
    ~/.gemini/GEMINI.md    -> ~/AGENTS.md

Every agent therefore reads identical content. Edit `ai/AGENTS.md` to change the
preferences for all of them.

Note the distinction: `ai/AGENTS.md` is *global* preferences for any project,
while the `CLAUDE.md` in this repo's root is guidance for working on **this**
repo. The latter is a symlink into `private-dotfiles` and is deliberately
untracked here.

## Day to day

Handy things that are easy to forget:

```sh
git cs                  # commit, prefixing [TASK-ID] parsed from the branch name
git delete-merged-branches
```

`git cs` expects branches to look like `TASK-123/short-description`; it takes
the text before the first `/` as the task id.

Shell helpers from `sh/.utility_functions` include `clean-phone` (strip a phone
number to digits, into the clipboard), `pair` (open a VNC session to a host),
and `start_vpn` / `stop_vpn`.

## Conventions for changes

- Shell scripts use `set -o errexit -o pipefail -o nounset`. Keep that on new
  ones, and keep them `shellcheck`-clean.
- Indentation is 4 spaces.
- To register a new dotfile, add both the file and an `ln -sf` line in
  `install.sh`.
- Decide which repo a file belongs in before adding it. Client names, internal
  hostnames, credentials, and anything describing the shape of private data go
  in `private-dotfiles` — this repo is public.
