# macOS system preferences

`install.sh` handles dotfile symlinks; `set-defaults.sh` handles everything that
lives in `defaults` instead of a file in `$HOME`.

Snapshotting the current preferences — to find the key behind a setting you
changed in the GUI — is `bkp backup macos`. That script and its docs live in
the private-dotfiles repo, because its output does. It has no
automated restore, and `set-defaults.sh` is the reason why: re-importing a whole
preference domain would drag the old machine's window frames and per-host state
along, so the snapshot's job is to tell you which key to add *here*.

## `set-defaults.sh`

Run once on a new machine. Idempotent, so re-running after you tweak the script
is fine. Prompts for `sudo` up front (firewall, software update, lock screen).

    ./macos/set-defaults.sh

Log out and back in afterwards — keyboard, trackpad, and appearance settings
don't fully apply until then. The script prints the list of things that can't be
scripted (iCloud, FileVault, Touch ID, login items, permission grants).

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
- Preference *snapshots* and their filtering rules are documented in the
  private-dotfiles repo's README, alongside the other backup targets.
