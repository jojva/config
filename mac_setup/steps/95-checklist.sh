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

french_pc_enabled() {
    defaults read com.apple.HIToolbox AppleEnabledInputSources 2>/dev/null \
        | grep -q '"KeyboardLayout Name" = "French-PC"'
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
todo "The French - PC input source is enabled" \
    "System Settings → Keyboard → Text Input → Edit… → +: French - PC for my own keyboard, French for the Mac's (Ukelele can remove the \` dead key)" \
    french_pc_enabled
todo "Azure CLI uses the Metis subscription" \
    "Run az login --tenant ${$(azure_tenant):-<Production tenant ID>} and choose Metis (a plain az login fails on the Production tenant's MFA)" \
    azure_on_metis
todo "~/.secretsrc is filled" \
    "Feel free to fill it with API keys and tokens (GitHub, Jira, Datadog...), it's sourced by .zshrc and not versioned" \
    secrets_filled

info "Also make sure that:"
info "  - fenêtre, Rectangle and Doll are allowed in System Settings → Privacy & Security → Accessibility"
info "  - AlgoliaSaaS is set up, see its README (~/workspace/AlgoliaSaaS)"
info "  - The Dell is the main display: System Settings → Displays → Dell → Use as: Main display"
