# Open each app once, one at a time, so that its first-launch requests (macOS
# confirmation, permissions, sign-in) are handled now, instead of all at once at
# the next login. An app counts as launched once it has created its preferences.

source ${0:A:h}/../lib.sh

# <app name>|<what to do when it opens>
first_launches=(
    "Docker|Accept the terms, then enter your password to install its helper"
    "Doll|Grant the Accessibility permission, then add Slack to show its badge"
    "Dropbox|Sign in"
    "Firefox|Confirm opening it"
    "Ghostty|Confirm opening it"
    "Rectangle|Grant the Accessibility permission and pick the default shortcuts"
    "Slack|Sign in to the Algolia workspace"
    "Spotify|Sign in"
)

launched_once() {
    local id=$(defaults read "$1/Contents/Info" CFBundleIdentifier 2>/dev/null)
    [[ -n $id && ( -f ~/Library/Preferences/$id.plist || -d ~/Library/Containers/$id ) ]]
}

for entry in $first_launches; do
    name=${entry%%|*} todo=${entry#*|}
    app=/Applications/$name.app
    if [[ ! -d $app ]]; then
        warn "$name is not installed"
        continue
    fi
    if launched_once $app; then
        ok "$name already launched once"
        continue
    fi
    if is_dry_run; then
        info "[dry-run] would open $name: $todo"
        continue
    fi
    run open $app
    info "$name: $todo"
    read -r "?    Press Enter once done: " </dev/tty
    if launched_once $app; then
        ok "$name launched once"
    else
        warn "$name hasn't saved its settings yet, it will be opened again on the next run"
    fi
done
