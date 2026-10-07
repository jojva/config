# SSH access to Algolia servers: the LDAP key, kept in 1Password and served by its
# SSH agent (only its public key is on disk, for .ssh/config), and
# ssh-signer-client, which .ssh/config calls. See
# https://algolia.atlassian.net/wiki/spaces/FOUNDATION/pages/2790785036 and
# https://github.com/algolia/ssh-key-signer/blob/master/README.md
# After dotfiles: tapping the private repo relies on .gitconfig's HTTPS → SSH rewrite.

source ${0:A:h}/../lib.sh

key_item="Prod LDAP SSH"
public_key=~/.ssh/algolia.pub
ldap_request_url="https://algolia.atlassian.net/servicedesk/customer/portal/159/group/553/create/1364"
token_url="https://github.com/settings/personal-access-tokens/15653576"
new_token_url="https://github.com/settings/personal-access-tokens/new"

# LDAP key: the signer signs the public key registered in LDAP
if write_public_key $key_item $public_key; then
    :
elif is_dry_run; then
    info "[dry-run] would ask for the \"$key_item\" SSH key in 1Password"
else
    warn "No \"$key_item\" SSH key in 1Password's $ONEPASSWORD_VAULT vault. In 1Password: New Item → SSH Key"
    info "  → Add Private Key, then either Import a Key File with the previous Mac's key (its"
    info "  public key is already in LDAP), or Generate a New Key (Ed25519). Title it \"$key_item\"."
    until write_public_key $key_item $public_key; do
        ask -r "answer?    Press Enter once it's in 1Password (or type 'skip'): "
        if [[ $answer == skip ]]; then
            warn "Skipped: SSH to Algolia servers won't work until the key exists"
            break
        fi
    done
    if [[ -f $public_key ]]; then
        ask -r "answer?    Is it a new key, not registered in LDAP yet? [y/N] "
        if [[ $answer == [yY]* ]]; then
            run pbcopy < $public_key
            info "Its public key is in the clipboard: paste it in the LDAP request that opens, to add"
            info "it to the jvalette LDAP account (the request also asks for an approver and the"
            info "phone number with Duo Mobile). SSH to servers works once the key is in LDAP."
            open_work_url $ldap_request_url
        fi
    fi
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
