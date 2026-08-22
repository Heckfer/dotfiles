# macOS system preferences

`install.sh` handles dotfile symlinks; these two scripts handle everything that
lives in `defaults` instead of a file in `$HOME`.

## `set-defaults.sh`

Run once on a new machine. Idempotent, so re-running after you tweak the script
is fine. Prompts for `sudo` up front (firewall, software update, lock screen).

    ./macos/set-defaults.sh

Log out and back in afterwards — keyboard, trackpad, and appearance settings
don't fully apply until then. The script prints the list of things that can't be
scripted (iCloud, FileVault, Touch ID, login items, permission grants).

## `backup.sh`

Dumps the managed preference domains and **writes outside this repo**, into the
private backup tree at `$BKP_ROOT` (`~/Documents/bkp` by default — see
`sh/.bkp_common`):

    ~/Documents/bkp/macos-defaults/20260822-143000/

This repo is public, and preference domains are full of recent-activity
history — recent folders, Go-to-Folder history, recent move destinations — which
leaks client names, production environment names and directory layouts. The
scripts are shareable; their output is not. `bkp_assert_not_in_git` refuses to
write anywhere inside a git work tree, and `.gitignore` catches output from
older copies of the script.

Each run diffs itself against the previous snapshot and prints what moved, which
is how you find the key behind a setting you changed in the GUI:

    ./macos/backup.sh          # baseline
    # change one thing in System Settings
    ./macos/backup.sh          # names the key that changed

Add that key to `set-defaults.sh` so it survives the next machine. The newest
`$BKP_KEEP` (10) snapshots are kept; older ones are pruned.

### Why the output is filtered

Even in a private tree, the snapshot only claims to record *settings*, so
`DROP_KEYS` strips recent-activity history, machine identifiers and churn.
Without it every run would diff dirty and the signal would be lost.

`render()` sorts keys, because plist key order is not stable between runs — that
sorting is what makes two snapshots comparable at all.

One trap worth knowing: history is not always stored as a path.
`FXRecentFolders` holds bare folder names — project and client directory names,
with no path attached — so scanning values for `/Users/...` never sees them.
Instead, any key whose *name* matches
`HISTORY_NAME_PATTERN` must appear in either `DROP_KEYS` or
`REVIEWED_SAFE_KEYS`; anything new is dropped and reported, so a future macOS
release adding a history key gets flagged rather than silently recorded.

## Notes

- Trackpad settings must be written to **both** `com.apple.AppleMultitouchTrackpad`
  (built-in) and `com.apple.driver.AppleBluetoothMultitouch.trackpad` (Magic
  Trackpad). `set-defaults.sh` does this via `trackpad_write`.
- Three-finger drag additionally needs the per-host
  `com.apple.trackpad.threeFingerDragGesture` flag, or the checkbox reads as on
  while the gesture does nothing.
- `set-defaults.sh` rebuilds the Dock from scratch (`persistent-apps -array`)
  so re-runs don't accumulate duplicates. Apps that aren't installed are
  skipped with a warning rather than added as broken tiles.
- Don't make a shell variable named `category` readonly before calling the
  `bkp_*` helpers — bash cannot shadow a readonly global with a local, and every
  helper that takes a category would fail.
