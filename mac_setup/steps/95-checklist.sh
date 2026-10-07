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

# Asks macOS for the enabled input sources: its preferences (com.apple.HIToolbox)
# don't reliably list custom layouts
layout_enabled() {
    local names
    names=$(osascript -l JavaScript -e '
        ObjC.import("Carbon");
        var sources = ObjC.castRefToObject($.TISCreateInputSourceList(null, false)), names = [];
        for (var i = 0; i < sources.count; i++) {
            names.push(ObjC.castRefToObject($.TISGetInputSourceProperty(
                sources.objectAtIndex(i), $.kTISPropertyLocalizedName)).js);
        }
        names.join("\n");' 2>/dev/null) || return 1
    (( ${${(f)names}[(Ie)$1]} ))
}

azure_on_metis() {
    [[ $(az account show --query name -o tsv 2>/dev/null) == Metis ]]
}

# The Production tenant's ID, read from alcli (cloned by the repos step) rather than
# versioned in this public repo
azure_tenant() {
    grep -oE 'AlgoliaAzureTenantID = "[^"]+"' ~/workspace/alcli/internal/config/providers.go 2>/dev/null \
        | cut -d'"' -f2
}

todo "Claude Code is signed in" \
    "Run claude and sign in with the Claude account (subscription)" claude_signed_in
for profile in algolia perso; do
    todo "Firefox $profile is signed in" \
        "Open Firefox $profile and sign in (passwords are on my phone, in the same profile), then restore the tabs from about:firefoxview" \
        firefox_signed_in $profile
done
todo "The Skillkorp input source is enabled" \
    "Create it with Ukelele and add it as an input source, see Keyboard layout in SETUP-Mac.md" \
    layout_enabled Skillkorp
todo "Azure CLI uses the Metis subscription" \
    "Run az login --tenant ${$(azure_tenant):-<Production tenant ID>} and choose Metis (a plain az login fails on the Production tenant's MFA)" \
    azure_on_metis

info "Also make sure that:"
info "  - fenêtre, Rectangle and Doll are allowed in System Settings → Privacy & Security → Accessibility"
info "  - AlgoliaSaaS is set up, see its README (~/workspace/AlgoliaSaaS)"
info "  - The Dell is the main display: System Settings → Displays → Dell → Use as: Main display"
