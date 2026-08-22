#!/usr/bin/env bash
#
# Snapshot the macOS preference domains that set-defaults.sh manages.
#
# The snapshot is written OUTSIDE this repo, into the private backup tree at
# $BKP_ROOT (see sh/.bkp_common). This repo is public, and preference domains
# are full of recent-activity history — recent folders, Go-to-Folder history,
# move destinations — which leaks client names and directory layouts. The
# scripts are shareable; their output is not.
#
# The snapshot is a *reference* dump, not a restore mechanism: re-importing a
# whole plist drags machine-specific state onto a new machine. Its job is to
# tell you which key backs a setting you changed in the GUI, so you can add it
# to set-defaults.sh. Each run diffs itself against the previous snapshot and
# prints what moved:
#
#     ./macos/backup.sh          # baseline
#     <change one thing in System Settings>
#     ./macos/backup.sh          # prints the key that changed
#
set -o errexit
set -o pipefail
set -o nounset

script_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly script_dir

# shellcheck source=../sh/.bkp_common
source "${script_dir}/../sh/.bkp_common"

# Distinct from the helpers' own `category` locals: bash cannot shadow a
# readonly global with a local, which breaks every helper that takes one.
readonly snapshot_category="macos-defaults"

bkp_assert_not_in_git

out_dir="$(bkp_new_dir "${snapshot_category}")"
readonly out_dir
entry="$(basename "${out_dir}")"
readonly entry

echo "Snapshotting to ${out_dir}"

python3 - "${out_dir}" <<'PY'
import os, plistlib, re, subprocess, sys, tempfile, urllib.parse

out_dir = sys.argv[1]

DOMAINS = [
    "NSGlobalDomain", "com.apple.dock", "com.apple.finder", "com.apple.Spotlight",
    "com.apple.AppleMultitouchTrackpad",
    "com.apple.driver.AppleBluetoothMultitouch.trackpad",
    "com.apple.driver.AppleBluetoothMultitouch.mouse", "com.apple.AppleMultitouchMouse",
    "com.apple.menuextra.clock", "com.apple.screencapture", "com.apple.controlcenter",
    "com.apple.systemuiserver", "com.apple.universalaccess", "com.apple.symbolichotkeys",
    "com.apple.HIToolbox", "com.apple.desktopservices", "com.apple.TextEdit",
    "com.apple.ActivityMonitor", "com.apple.print.PrintingPrefs",
    "com.apple.LaunchServices", "com.apple.CrashReporter",
    "com.apple.frameworks.diskimages", "com.apple.ImageCapture",
]
BYHOST_DOMAINS = ["com.apple.screensaver", "com.apple.controlcenter", "com.apple.Bluetooth"]

# Keys holding recent-activity history, machine identifiers, or pure churn.
# Dropped because they are not settings: they would swamp the diff and make
# every run look like a change. Exact key names, so managed settings with
# similar names (`show-recents`, screencapture's `location`) survive.
DROP_KEYS = {
    # Finder history.
    "FXRecentFolders", "GoToField", "GoToFieldHistory",
    "RecentMoveAndCopyDestinations", "FXConnectToLastURL", "FXConnectToBounds",
    "DataSeparatedDisplayNameCache",
    "FXDetachedDesktopProviderID", "FXDetachedDocumentsProviderID",
    "CopyProgressWindowLocation", "EmptyTrashProgressWindowLocation",
    "NSOSPLastRootDirectory", "NSWindow Frame GoToSheet", "NSWindow Frame GoToWindow",
    # NSGlobalDomain navigation history.
    "NSNavRecentPlaces", "NSNavLastRootDirectory", "NSNavLastCurrentDirectory",
    "NSNavPanelExpandedSizeForOpenMode", "NSNavPanelExpandedSizeForSaveMode",
    # Dock churn and identifiers.
    "recent-apps", "last-analytics-stamp", "mod-count", "lastShowIndicatorTime",
    "trash-full", "region", "loc",
    # Screenshot churn.
    "last-selection", "last-selection-display", "location-last",
    # Machine/boot identifiers and timestamped logs.
    "PayloadUUID", "CleanExit", "History",
    "memoryExceptionProcesses.bootUUID", "patternMatchServiceCrashes.bootUUID",
}

# A key whose NAME looks like history must be either dropped above or declared
# safe below. This catches history that a value scan would miss: FXRecentFolders
# stores bare folder names (project and client directory names) with no path to
# grep for, so a new macOS release adding such a key is reported rather than
# silently recorded.
HISTORY_NAME_PATTERN = re.compile(
    r"recent|history|goto|lastused|lastroot|lastcurrent|lastopen", re.I
)

# Inspected and found to hold view settings or version stamps, not history.
REVIEWED_SAFE_KEYS = {
    "show-recents", "RecentsArrangeGroupViewBy", "SearchRecentsSavedViewStyle",
    "SearchRecentsSavedViewStyleVersion", "SearchRecentsViewSettings",
    "ShowRecentTags", "PasteboardHistoryVersion",
    # Finder list-view column identifier.
    "dateLastOpened",
}

unreviewed = []


def scrub(value, domain):
    """Drop denylisted keys and replace opaque bookmark blobs."""
    if isinstance(value, dict):
        kept = {}
        for key, item in value.items():
            if key in DROP_KEYS:
                continue
            if HISTORY_NAME_PATTERN.search(key) and key not in REVIEWED_SAFE_KEYS:
                unreviewed.append(f"{domain}: {key}")
                continue
            kept[key] = scrub(item, domain)
        return kept
    if isinstance(value, list):
        return [scrub(v, domain) for v in value]
    if isinstance(value, bytes):
        return f"<{len(value)} bytes elided>"
    return value


def render(value, indent=0):
    """Stable, sorted, diff-friendly rendering. Sorting is what makes two
    snapshots comparable — plist key order is not stable across runs."""
    pad = "    " * indent
    if isinstance(value, dict):
        lines = ["{"]
        for key in sorted(value, key=str):
            lines.append(f"{pad}    {key} = {render(value[key], indent + 1)};")
        lines.append(pad + "}")
        return "\n".join(lines)
    if isinstance(value, list):
        if not value:
            return "()"
        lines = ["("]
        for item in value:
            lines.append(f"{pad}    {render(item, indent + 1)},")
        lines.append(pad + ")")
        return "\n".join(lines)
    return str(value)


def dump(domain, byhost):
    cmd = ["defaults"] + (["-currentHost"] if byhost else []) + ["export", domain, "-"]
    result = subprocess.run(cmd, capture_output=True)
    if result.returncode != 0 or not result.stdout.strip():
        return None
    data = plistlib.loads(result.stdout)
    if not data:
        return None
    return render(scrub(data, domain)) + "\n"


for domain in DOMAINS:
    text = dump(domain, byhost=False)
    if text is None:
        print(f"  {domain} (not set, skipped)")
        continue
    with open(os.path.join(out_dir, f"{domain}.txt"), "w") as handle:
        handle.write(text)
    print(f"  {domain}")

for domain in BYHOST_DOMAINS:
    text = dump(domain, byhost=True)
    if text is None:
        continue
    with open(os.path.join(out_dir, f"byhost.{domain}.txt"), "w") as handle:
        handle.write(text)
    print(f"  {domain} (byhost)")

# Dock contents, human-readable. The raw entries carry bookmark blobs and
# mod dates that churn on every Dock interaction.
with tempfile.TemporaryDirectory() as tmp:
    path = os.path.join(tmp, "dock.plist")
    subprocess.run(["defaults", "export", "com.apple.dock", path], check=True)
    with open(path, "rb") as handle:
        dock = plistlib.load(handle)

lines = []
for section in ("persistent-apps", "persistent-others"):
    lines.append(f"== {section}")
    for item in dock.get(section, []):
        tile = item.get("tile-data", {})
        url = urllib.parse.unquote((tile.get("file-data") or {}).get("_CFURLString", ""))
        label = tile.get("file-label") or tile.get("label") or "?"
        extra = ""
        if section == "persistent-others":
            extra = " showas={} displayas={} arrangement={}".format(
                tile.get("showas"), tile.get("displayas"), tile.get("arrangement")
            )
        lines.append(f"  {label:<30} {url}{extra}")

with open(os.path.join(out_dir, "dock-items.txt"), "w") as handle:
    handle.write("\n".join(lines) + "\n")
print("  dock items")

# State that `defaults` cannot reach.
info = ["== System info"]
info.append(subprocess.run(["sw_vers"], capture_output=True, text=True).stdout.strip())
info.append("")
info.append("== Computer / host names")
for key in ("ComputerName", "LocalHostName"):
    got = subprocess.run(["scutil", "--get", key], capture_output=True, text=True)
    info.append(f"{key}: {got.stdout.strip() or '?'}")
info.append("")
info.append("== Login items")
got = subprocess.run(
    ["osascript", "-e", 'tell application "System Events" to get the name of every login item'],
    capture_output=True, text=True,
)
info.append(got.stdout.strip() or "(unavailable)")

with open(os.path.join(out_dir, "system.txt"), "w") as handle:
    handle.write("\n".join(info) + "\n")
print("  system info")

if unreviewed:
    print("\nUnreviewed history-like keys, dropped as a precaution.", file=sys.stderr)
    print("Inspect each, then add it to DROP_KEYS or REVIEWED_SAFE_KEYS:\n", file=sys.stderr)
    for entry in sorted(set(unreviewed)):
        print(f"  {entry}", file=sys.stderr)
PY

previous="$(bkp_previous "${snapshot_category}" "${entry}")"
echo
if [ -z "${previous}" ]; then
    echo "First snapshot — nothing to compare against."
else
    previous_dir="${BKP_ROOT}/${snapshot_category}/${previous}"
    echo "Changes since ${previous}:"
    if diff -ru "${previous_dir}" "${out_dir}" > /tmp/bkp-macos-diff.$$ 2>&1; then
        echo "  (no changes)"
    else
        sed 's/^/  /' /tmp/bkp-macos-diff.$$
    fi
    rm -f /tmp/bkp-macos-diff.$$
fi

bkp_prune "${snapshot_category}"

echo
echo "Snapshot: ${out_dir}"
