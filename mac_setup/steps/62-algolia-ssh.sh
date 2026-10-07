# SSH access to Algolia servers: the LDAP key and ssh-signer-client, which
# mac_dotfiles/.ssh/config calls. See
# https://algolia.atlassian.net/wiki/spaces/FOUNDATION/pages/2790785036 and
# https://github.com/algolia/ssh-key-signer/blob/master/README.md
# After dotfiles: tapping the private repo relies on .gitconfig's HTTPS → SSH rewrite.

source ${0:A:h}/../lib.sh

key=~/.ssh/algolia
email=$(git config -f $REPO_DIR/common_dotfiles/.gitconfig user.email)
ldap_request_url="https://algolia.atlassian.net/servicedesk/customer/portal/159/group/553/create/1364"
token_url="https://github.com/settings/personal-access-tokens/15653576"
new_token_url="https://github.com/settings/personal-access-tokens/new"

# LDAP key: the signer signs the public key registered in LDAP
if [[ -f $key ]]; then
    ok "$key exists"
elif is_dry_run; then
    info "[dry-run] would ask to copy $key from the previous Mac, or generate a new one"
else
    warn "No $key: copy it (and $key:t.pub) from the previous Mac now, its public key is already in LDAP"
    ask -r "?    Press Enter once copied, or to generate a new key: "
    if [[ -f $key ]]; then
        ok "$key copied"
    else
        info "Generating $key, choose a passphrase"
        run ssh-keygen -t ed25519 -C $email -f $key
        run pbcopy < $key.pub
        info "Its public key is in the clipboard: paste it in the LDAP request that opens, to add"
        info "it to the jvalette LDAP account (the request also asks for an approver and the"
        info "phone number with Duo Mobile). SSH to servers works once the key is in LDAP."
        open_work_url $ldap_request_url
    fi
fi

# Keep the passphrase in the keychain. The macOS agent forgets its keys at each
# logout: --apple-load-keychain reloads, silently, those whose passphrase is in the
# keychain (UseKeychain in .ssh/config does the same when connecting).
in_agent() {
    ssh-add -l 2>/dev/null | grep -qF "$(ssh-keygen -lf $key.pub 2>/dev/null | cut -d' ' -f2)"
}
if ssh-keygen -y -P "" -f $key >/dev/null 2>&1; then
    ok "$key has no passphrase"
elif in_agent || { ssh-add --apple-load-keychain -q >/dev/null 2>&1; in_agent }; then
    ok "$key's passphrase is in the keychain"
elif [[ -f $key ]]; then
    run ssh-add --apple-use-keychain $key
fi

# ssh-signer-client, from a private tap: the formula downloads a private release,
# which needs a GitHub token, kept in 1Password (.zshrc's brew function reads it too,
# so that brew upgrade can update it).
ensure_brew_trust algolia/private/ssh-signer-client
if brew list ssh-signer-client >/dev/null 2>&1; then
    ok "ssh-signer-client installed"
elif is_dry_run; then
    info "[dry-run] would install algolia/private/ssh-signer-client with its GitHub token"
else
    require_secret HOMEBREW_GITHUB_API_TOKEN "op://Employee/GitHub token - ssh-key-signer/credential" \
        "A GitHub token lets Homebrew install and update ssh-signer-client." \
        "Regenerate it at $token_url, or if that page doesn't exist anymore, create one at" \
        "$new_token_url with: Token name ssh-key-signer, Resource owner algolia," \
        "Expiration 365 days, Only select repositories ssh-key-signer and homebrew-private," \
        "Repository permissions Contents read-only." \
        "Save it in 1Password: API Credential \"GitHub token - ssh-key-signer\" in the Employee vault."
    run brew tap algolia/private
    run brew install algolia/private/ssh-signer-client
fi
ensure_symlink $HOMEBREW_PREFIX/opt/ssh-signer-client/bin/ssh-signer-client ~/bin/ssh-signer-client
