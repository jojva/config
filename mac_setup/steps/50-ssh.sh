# SSH key for GitHub, kept in 1Password and served by its SSH agent: no key file on
# disk. Only I can create it (1Password's browser extension) and authorize it for
# the algolia organization's SSO.

source ${0:A:h}/../lib.sh

keys_url="https://github.com/settings/keys"

# Uses 1Password's agent explicitly: on a fresh Mac, the dotfiles step hasn't linked
# ~/.ssh/config yet. The socket path has a space, hence the quotes inside the option.
# GitHub answers "successfully authenticated" but exits with 1.
github_auth_ok() {
    local out
    out=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new \
        -o "IdentityAgent=\"$ONEPASSWORD_AGENT_SOCKET\"" -T git@github.com 2>&1) || true
    [[ $out == *'successfully authenticated'* ]]
}

if github_auth_ok; then
    ok "GitHub accepts the SSH key from 1Password"
    exit 0
fi
if is_dry_run; then
    info "[dry-run] would ask to create the GitHub SSH key in 1Password"
    exit 0
fi

warn "GitHub doesn't accept any SSH key from 1Password yet. In the page that opens:"
info "  1. Use the 1Password extension's \"Set up SSH for GitHub\" (authentication key)"
info "  2. Next to the new key, click Configure SSO → Authorize for algolia"
open_work_url $keys_url
until github_auth_ok; do
    ask -r "answer?    Press Enter once done (or type 'skip'): "
    if [[ $answer == skip ]]; then
        warn "Skipped: GitHub over SSH won't work until the key exists"
        exit 0
    fi
done
ok "GitHub accepts the SSH key from 1Password"
