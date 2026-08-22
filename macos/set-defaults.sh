#!/usr/bin/env bash
#
# Apply Fernando's macOS system preferences on a fresh machine.
#
# Idempotent — safe to re-run. Captured from macOS 26.6 (Tahoe); key names are
# stable across recent releases but a few may be no-ops on much older ones.
#
# Some settings cannot be scripted and are listed at the end of the run.
#
# Usage: ./set-defaults.sh
#
set -o errexit
set -o pipefail
set -o nounset

readonly screenshot_dir="${HOME}/Desktop/screenshots"

# Both domains must be written: the first is the built-in trackpad, the second
# the Magic Trackpad. System Settings keeps them in sync; scripts must too.
readonly trackpad_domains=(
    com.apple.AppleMultitouchTrackpad
    com.apple.driver.AppleBluetoothMultitouch.trackpad
)

trackpad_write() {
    local key="$1" type="$2" value="$3" domain
    for domain in "${trackpad_domains[@]}"; do
        defaults write "${domain}" "${key}" "${type}" "${value}"
    done
}

section() {
    printf '\n== %s\n' "$1"
}

# Prompt for sudo once up front — the firewall, lock-screen, and software
# update sections need it, and they run near the end.
sudo -v

section "Appearance"
defaults write NSGlobalDomain AppleInterfaceStyle -string "Dark"
defaults delete NSGlobalDomain AppleInterfaceStyleSwitchesAutomatically 2>/dev/null || true
# Let macOS decide when to show scroll bars based on the input device.
# Other values: "WhenScrolling", "Always".
defaults write NSGlobalDomain AppleShowScrollBars -string "Automatic"
# Clicking the scroll bar track jumps to that spot instead of paging.
defaults write NSGlobalDomain AppleScrollerPagingBehavior -bool true
# Prefer tabs over new windows in document apps.
defaults write NSGlobalDomain AppleWindowTabbingMode -string "always"

section "Region and units"
defaults write NSGlobalDomain AppleMeasurementUnits -string "Centimeters"
defaults write NSGlobalDomain AppleMetricUnits -bool true
defaults write NSGlobalDomain AppleTemperatureUnit -string "Celsius"
defaults write NSGlobalDomain AppleICUForce24HourTime -bool true

section "Trackpad"
# Tap to click.
trackpad_write Clicking -bool true
# Three-finger drag. The gesture also needs the per-host global flag; without
# it the checkbox reads as on but the gesture does nothing.
trackpad_write TrackpadThreeFingerDrag -bool true
defaults -currentHost write NSGlobalDomain com.apple.trackpad.threeFingerDragGesture -bool true
# Three-finger swipes off, since three fingers are spoken for by dragging.
trackpad_write TrackpadThreeFingerHorizSwipeGesture -int 0
trackpad_write TrackpadThreeFingerVertSwipeGesture -int 0
trackpad_write TrackpadThreeFingerTapGesture -int 0
# Four-finger swipes drive Spaces and Mission Control instead.
trackpad_write TrackpadFourFingerHorizSwipeGesture -int 2
trackpad_write TrackpadFourFingerVertSwipeGesture -int 2
trackpad_write TrackpadFourFingerPinchGesture -int 2
trackpad_write TrackpadFiveFingerPinchGesture -int 2
# Two-finger secondary click; drag-lock and click-drag off.
trackpad_write TrackpadRightClick -bool true
trackpad_write TrackpadCornerSecondaryClick -int 0
trackpad_write Dragging -bool false
trackpad_write DragLock -bool false
# Two-finger double tap for Look Up / smart zoom.
trackpad_write TrackpadTwoFingerDoubleTapGesture -int 1
# Two-finger swipe from the right edge opens Notification Center.
trackpad_write TrackpadTwoFingerFromRightEdgeSwipeGesture -int 3
trackpad_write TrackpadHandResting -bool true
# Keep the trackpad live when a USB mouse is attached.
trackpad_write USBMouseStopsTrackpad -bool false
trackpad_write UserPreferences -bool true

section "Keyboard and text"
# Fast key repeat. InitialKeyRepeat/KeyRepeat are in 15ms ticks; these are
# below the System Settings slider minimums, which is the point.
defaults write NSGlobalDomain InitialKeyRepeat -int 15
defaults write NSGlobalDomain KeyRepeat -int 2
defaults write NSGlobalDomain NSAutomaticCapitalizationEnabled -bool true
defaults write NSGlobalDomain NSAutomaticPeriodSubstitutionEnabled -bool true
# Straight quotes and dashes — smart substitution mangles code and paths.
defaults write NSGlobalDomain NSAutomaticQuoteSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticDashSubstitutionEnabled -bool false
defaults write NSGlobalDomain NSAutomaticSpellingCorrectionEnabled -bool false
# Key-repeat on press-and-hold instead of the accent character picker.
defaults write NSGlobalDomain ApplePressAndHoldEnabled -bool false
# Full keyboard access: Tab moves between every control in dialogs, not just
# text fields and lists.
defaults write NSGlobalDomain AppleKeyboardUIMode -int 3

section "Dock"
defaults write com.apple.dock orientation -string "left"
defaults write com.apple.dock tilesize -int 41
defaults write com.apple.dock magnification -bool true
defaults write com.apple.dock largesize -int 69
defaults write com.apple.dock autohide -bool true
# Make the auto-hide reveal instant instead of the default ~0.5s dwell.
defaults write com.apple.dock autohide-delay -float 0
defaults write com.apple.dock autohide-time-modifier -float 0.15
# Minimize into the app's own icon rather than a separate Dock tile.
defaults write com.apple.dock minimize-to-application -bool false
# Group Mission Control windows by application.
defaults write com.apple.dock expose-group-apps -bool true
# No recent-applications section.
defaults write com.apple.dock show-recents -bool false
# Dot under running apps.
defaults write com.apple.dock show-process-indicators -bool true
# Don't reorder Spaces by most-recent-use — keeps four-finger swipes predictable.
defaults write com.apple.dock mru-spaces -bool false
# Dim hidden apps' Dock icons so cmd-H state is visible.
defaults write com.apple.dock showhidden -bool true
# Faster Launchpad / Mission Control animations.
defaults write com.apple.dock springboard-show-duration -float 0.1
defaults write com.apple.dock springboard-hide-duration -float 0.1
defaults write com.apple.dock expose-animation-duration -float 0.12

section "Hot corners"
# 1 = disabled, 2 = Mission Control, 3 = app windows, 4 = Desktop,
# 5 = start screen saver, 6 = disable screen saver, 7 = Dashboard,
# 10 = put display to sleep, 11 = Launchpad, 12 = Notification Center,
# 13 = Lock Screen, 14 = Quick Note.
defaults write com.apple.dock wvous-br-corner -int 1
defaults write com.apple.dock wvous-br-modifier -int 0
defaults delete com.apple.dock wvous-tl-corner 2>/dev/null || true
defaults delete com.apple.dock wvous-tr-corner 2>/dev/null || true
defaults delete com.apple.dock wvous-bl-corner 2>/dev/null || true

section "Dock contents"
# Rebuild from scratch so re-runs don't accumulate duplicates.
defaults write com.apple.dock persistent-apps -array
defaults write com.apple.dock persistent-others -array

dock_add_app() {
    local app_path="$1"
    if [[ ! -e "${app_path}" ]]; then
        echo "  skipping (not installed): ${app_path}"
        return
    fi
    defaults write com.apple.dock persistent-apps -array-add "
        <dict>
            <key>tile-data</key>
            <dict>
                <key>file-data</key>
                <dict>
                    <key>_CFURLString</key><string>${app_path}</string>
                    <key>_CFURLStringType</key><integer>0</integer>
                </dict>
            </dict>
        </dict>"
    echo "  added ${app_path##*/}"
}

# showas: 1 = fan, 2 = grid, 3 = list, 0 = automatic.
# displayas: 0 = stack, 1 = folder.
# arrangement: 1 = name, 2 = date added, 3 = date modified, 4 = date created, 5 = kind.
dock_add_folder() {
    local folder_path="$1" arrangement="$2" displayas="$3" showas="$4"
    if [[ ! -d "${folder_path}" ]]; then
        echo "  skipping (missing): ${folder_path}"
        return
    fi
    defaults write com.apple.dock persistent-others -array-add "
        <dict>
            <key>tile-data</key>
            <dict>
                <key>file-data</key>
                <dict>
                    <key>_CFURLString</key><string>file://${folder_path}/</string>
                    <key>_CFURLStringType</key><integer>15</integer>
                </dict>
                <key>arrangement</key><integer>${arrangement}</integer>
                <key>displayas</key><integer>${displayas}</integer>
                <key>showas</key><integer>${showas}</integer>
            </dict>
            <key>tile-type</key><string>directory-tile</string>
        </dict>"
    echo "  added folder ${folder_path##*/}"
}

dock_add_app "/System/Applications/Calendar.app"
dock_add_app "/Applications/Sublime Text.app"
dock_add_app "/System/Applications/iPhone Mirroring.app"

# Downloads as a fan, sorted by date added.
dock_add_folder "${HOME}/Downloads" 2 0 1

section "Finder"
# Column view by default. Others: icnv (icon), Nlsv (list), glyv (gallery).
defaults write com.apple.finder FXPreferredViewStyle -string "clmv"
# New windows open in Downloads.
defaults write com.apple.finder NewWindowTarget -string "PfLo"
defaults write com.apple.finder NewWindowTargetPath -string "file://${HOME}/Downloads/"
defaults write com.apple.finder ShowSidebar -bool true
# Search the current folder, not the whole Mac.
defaults write com.apple.finder FXDefaultSearchScope -string "SCcf"
defaults write com.apple.finder _FXSortFoldersFirst -bool false
# Auto-empty Trash after 30 days.
defaults write com.apple.finder FXRemoveOldTrashItems -bool true
defaults write NSGlobalDomain AppleShowAllExtensions -bool true
# Path bar and status bar: cheap orientation, no downside.
defaults write com.apple.finder ShowPathbar -bool true
defaults write com.apple.finder ShowStatusBar -bool true
# Full POSIX path in the window title.
defaults write com.apple.finder _FXShowPosixPathInTitle -bool true
# No nag when changing a file extension.
defaults write com.apple.finder FXEnableExtensionChangeWarning -bool false
# No confirmation prompt when emptying the Trash.
defaults write com.apple.finder WarnOnEmptyTrash -bool false
# Spring-loaded folders while dragging.
defaults write NSGlobalDomain com.apple.springing.enabled -bool true
defaults write NSGlobalDomain com.apple.springing.delay -float 0.5
# Don't write .DS_Store on network or USB volumes.
defaults write com.apple.desktopservices DSDontWriteNetworkStores -bool true
defaults write com.apple.desktopservices DSDontWriteUSBStores -bool true
# Expand Save and Print dialogs by default.
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode -bool true
defaults write NSGlobalDomain NSNavPanelExpandedStateForSaveMode2 -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint -bool true
defaults write NSGlobalDomain PMPrintingExpandedStateForPrint2 -bool true
# Save to disk, not iCloud, by default.
defaults write NSGlobalDomain NSDocumentSaveNewDocumentsToCloud -bool false
# Skip the "are you sure you want to open this" quarantine dialog for apps
# already vetted at download time.
defaults write com.apple.LaunchServices LSQuarantine -bool false
# Don't verify disk images before mounting.
defaults write com.apple.frameworks.diskimages skip-verify -bool true
# Don't launch Photos when a device is plugged in.
defaults write com.apple.ImageCapture disableHotPlug -bool true

section "Desktop and icon view"
# Desktop icon layout: no auto-arrange, 64pt icons, no item info.
/usr/libexec/PlistBuddy \
    -c "Set :DesktopViewSettings:IconViewSettings:arrangeBy none" \
    -c "Set :DesktopViewSettings:IconViewSettings:iconSize 64" \
    -c "Set :DesktopViewSettings:IconViewSettings:gridSpacing 54" \
    -c "Set :DesktopViewSettings:IconViewSettings:textSize 12" \
    -c "Set :DesktopViewSettings:IconViewSettings:labelOnBottom true" \
    -c "Set :DesktopViewSettings:IconViewSettings:showItemInfo false" \
    -c "Set :DesktopViewSettings:IconViewSettings:showIconPreview true" \
    ~/Library/Preferences/com.apple.finder.plist 2>/dev/null \
    || echo "  desktop view settings not initialized yet — set once in Finder, then re-run"
# No drives or servers on the Desktop.
defaults write com.apple.finder ShowHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowExternalHardDrivesOnDesktop -bool false
defaults write com.apple.finder ShowRemovableMediaOnDesktop -bool false
defaults write com.apple.finder ShowMountedServersOnDesktop -bool false

section "Spotlight"
# Only these categories are searched; order is the results order. Everything
# else is off, which also keeps indexing cheap.
defaults write com.apple.Spotlight orderedItems -array \
    '{"enabled"=1;"name"="APPLICATIONS";}' \
    '{"enabled"=1;"name"="MENU_EXPRESSION";}' \
    '{"enabled"=0;"name"="CONTACT";}' \
    '{"enabled"=1;"name"="MENU_CONVERSION";}' \
    '{"enabled"=0;"name"="MENU_DEFINITION";}' \
    '{"enabled"=0;"name"="DOCUMENTS";}' \
    '{"enabled"=0;"name"="EVENT_TODO";}' \
    '{"enabled"=0;"name"="DIRECTORIES";}' \
    '{"enabled"=0;"name"="FONTS";}' \
    '{"enabled"=0;"name"="IMAGES";}' \
    '{"enabled"=0;"name"="MESSAGES";}' \
    '{"enabled"=0;"name"="MOVIES";}' \
    '{"enabled"=0;"name"="MUSIC";}' \
    '{"enabled"=0;"name"="MENU_OTHER";}' \
    '{"enabled"=0;"name"="PDF";}' \
    '{"enabled"=0;"name"="PRESENTATIONS";}' \
    '{"enabled"=0;"name"="MENU_SPOTLIGHT_SUGGESTIONS";}' \
    '{"enabled"=0;"name"="SPREADSHEETS";}' \
    '{"enabled"=1;"name"="SYSTEM_PREFS";}' \
    '{"enabled"=0;"name"="TIPS";}' \
    '{"enabled"=0;"name"="BOOKMARKS";}' \
    '{"enabled"=1;"name"="SOURCE";}'

section "Menu bar clock"
defaults write com.apple.menuextra.clock ShowDayOfWeek -bool true
defaults write com.apple.menuextra.clock ShowDate -int 0
# Moot under 24-hour time, but keep it explicit.
defaults write com.apple.menuextra.clock ShowAMPM -bool false
# Show the seconds-resolution flashing separator off; battery percentage on.
defaults write com.apple.menuextra.clock FlashDateSeparators -bool false
defaults -currentHost write com.apple.controlcenter BatteryShowPercentage -bool true

section "Screenshots"
mkdir -p "${screenshot_dir}"
defaults write com.apple.screencapture location -string "${screenshot_dir}"
defaults write com.apple.screencapture style -string "selection"
defaults write com.apple.screencapture target -string "file"
defaults write com.apple.screencapture video -bool true
# No drop shadow on window captures.
defaults write com.apple.screencapture disable-shadow -bool true
defaults write com.apple.screencapture type -string "png"
# Skip the floating thumbnail that has to be dismissed before the file lands.
defaults write com.apple.screencapture show-thumbnail -bool false

section "Screen saver and lock"
defaults -currentHost write com.apple.screensaver idleTime -int 300
# Require the password 5s after sleep or screen saver starts.
sudo defaults write /Library/Preferences/com.apple.screensaver askForPassword -int 1
sudo defaults write /Library/Preferences/com.apple.screensaver askForPasswordDelay -int 5

section "Sound and feedback"
# Play the feedback sound when the volume keys are pressed.
defaults write NSGlobalDomain com.apple.sound.beep.feedback -bool true

section "Misc app defaults"
# TextEdit: plain text, UTF-8.
defaults write com.apple.TextEdit RichText -int 0
defaults write com.apple.TextEdit PlainTextEncoding -int 4
defaults write com.apple.TextEdit PlainTextEncodingForWrite -int 4
# Activity Monitor: show all processes, sorted by CPU, CPU history in the icon.
defaults write com.apple.ActivityMonitor ShowCategory -int 0
defaults write com.apple.ActivityMonitor SortColumn -string "CPUUsage"
defaults write com.apple.ActivityMonitor SortDirection -int 0
defaults write com.apple.ActivityMonitor IconType -int 5
# Crash reporter as a notification instead of a modal dialog.
defaults write com.apple.CrashReporter UseUNC -int 1
# Expand print dialogs and quit the print queue app when done.
defaults write com.apple.print.PrintingPrefs "Quit When Finished" -bool true
# Automatic software update checks; install security responses automatically.
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticCheckEnabled -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate AutomaticDownload -bool true
sudo defaults write /Library/Preferences/com.apple.SoftwareUpdate CriticalUpdateInstall -bool true

section "Security"
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setglobalstate on >/dev/null
sudo /usr/libexec/ApplicationFirewall/socketfilterfw --setstealthmode on >/dev/null

section "Restarting affected apps"
for app in Dock Finder SystemUIServer; do
    killall "${app}" >/dev/null 2>&1 || true
done

cat <<'MANUAL'

Applied. Some settings need a logout, and some cannot be scripted at all.

Cannot be scripted — do these by hand:
  - iCloud / Apple ID sign-in
  - Touch ID and Apple Watch unlock
  - FileVault
  - Keyboard shortcut remaps beyond the defaults (System Settings > Keyboard)
  - Notification permissions and Focus modes
  - Wallpaper (scriptable but per-display and fragile; set it once)
  - Login items (System Settings > General > Login Items)
  - Default browser
  - Accessibility / Full Disk Access grants for terminals and tools
  - Keychron K12 Pro keymap: flash keyboard/*.json via the QMK/VIA web app

Log out and back in for keyboard, trackpad, and appearance settings to fully take.
MANUAL
