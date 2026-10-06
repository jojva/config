# Okta VPN profile in OpenVPN Connect, see
# https://algolia.atlassian.net/wiki/spaces/FOUNDATION/pages/226165046
# The profile comes from Google Drive and isn't versioned: it holds keys.
# Connecting stays manual (Okta Verify push).

source ${0:A:h}/../lib.sh

openvpn="/Applications/OpenVPN Connect/OpenVPN Connect.app/Contents/MacOS/OpenVPN Connect"
profile_name="Algolia VPN"
profile_url="https://drive.google.com/file/d/1aMWzEP7wkbvWOHmrapBaGHhrhYKlDcgk/view?usp=sharing"
email=$(git config -f $REPO_DIR/common_dotfiles/.gitconfig user.email)

# Read the whole list before searching it: OpenVPN Connect shows a JavaScript
# error (EPIPE) when its output pipe closes early, e.g. with grep -q.
has_profile() {
    local profiles
    profiles=$("$openvpn" --list-profiles 2>/dev/null) || return 1
    [[ $profiles == *"\"$profile_name\""* ]]
}

# ensure_setting <name> <value>
ensure_setting() {
    local settings
    settings=$("$openvpn" --list-settings 2>/dev/null) || settings=""
    if [[ $settings == *"\"$1\": $2"[,$'\n']* || $settings == *"\"$1\": \"$2\""* ]]; then
        ok "OpenVPN Connect $1 = $2"
        return 0
    fi
    run "$openvpn" --set-setting=$1 --value=$2
}

import_profile() {
    info "Accepting OpenVPN Connect's GDPR notice and skipping its onboarding"
    run "$openvpn" --accept-gdpr
    run "$openvpn" --skip-startup-dialogs

    info "Download the VPN profile (.ovpn) from Google Drive, in the Firefox algolia window that opens"
    open_work_url $profile_url
    read -r "?    Press Enter once it's in ~/Downloads: " </dev/tty

    local profiles=( ~/Downloads/*.ovpn(N.om) )
    if (( ! $#profiles )); then
        err "No .ovpn file in ~/Downloads, re-run this step once it's downloaded"
        exit 1
    fi
    run "$openvpn" --import-profile=$profiles[1] --name=$profile_name --username=$email

    if ! has_profile; then
        err "The import failed, see OpenVPN Connect's output above"
        exit 1
    fi
    ok "Imported $profiles[1]:t as $profile_name, connect from OpenVPN Connect (Okta Verify push)"
    info "To not type the Okta password at each connection, save it in OpenVPN Connect:"
    info "edit the $profile_name profile (pencil icon) → Password"
    warn "$profiles[1] holds the VPN keys, delete it once you've checked the VPN works"
}

if has_profile; then
    ok "OpenVPN Connect has the $profile_name profile"
elif is_dry_run; then
    info "[dry-run] would download the VPN profile and import it into OpenVPN Connect"
else
    import_profile
fi

# The VPN is only needed now and then: don't start it at login
ensure_setting launch-at-startup false
