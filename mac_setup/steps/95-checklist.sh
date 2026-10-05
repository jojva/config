# What's left to do by hand after the setup. Items that can be checked show ✓
# once done. This step never fails.

source ${0:A:h}/../lib.sh

firefox_dir=~/Library/Application\ Support/Firefox

# todo <description> <hint shown while not done> <check command...>
todo() {
    local desc=$1 hint=$2
    shift 2
    if "$@"; then
        ok $desc
    else
        warn "To do: $desc"
        info "  $hint"
    fi
}

claude_signed_in() {
    claude auth status 2>/dev/null | grep -q '"loggedIn": true'
}

firefox_signed_in() {
    local dir=$(awk -F= -v name=$1 '/^\[/ { n = "" } $1 == "Name" { n = $2 } $1 == "Path" && n == name { print $2 }' \
        $firefox_dir/profiles.ini 2>/dev/null)
    [[ -n $dir && -f $firefox_dir/$dir/signedInUser.json ]]
}

secrets_filled() {
    grep -qvE '^[[:space:]]*(#|$)' ~/.secretsrc 2>/dev/null
}

todo "Claude Code is signed in" \
    "Run claude and sign in with the Claude account (subscription)" claude_signed_in
for profile in algolia perso; do
    todo "Firefox $profile is signed in" \
        "Open Firefox $profile and sign in (passwords are on my phone, in the same profile), then restore the tabs from about:firefoxview" \
        firefox_signed_in $profile
done
todo "~/.secretsrc is filled" "Copy the secrets from the previous Mac" secrets_filled

info "Can't be checked: fenêtre, Rectangle and Doll must be allowed in"
info "System Settings → Privacy & Security → Accessibility"
