# SSH key for GitHub: generate it, add it to the keychain, upload it with gh.

source ${0:A:h}/../lib.sh

key=~/.ssh/id_ed25519
email=$(git config -f $REPO_DIR/common_dotfiles/.gitconfig user.email)

github_auth_ok() {
    # GitHub answers "successfully authenticated" but exits with 1, as it gives no shell
    local out
    out=$(ssh -o BatchMode=yes -o StrictHostKeyChecking=accept-new -T git@github.com 2>&1) || true
    [[ $out == *'successfully authenticated'* ]]
}

if [[ -f $key ]]; then
    ok "$key exists"
else
    [[ -d ${key:h} ]] || run mkdir -m 700 ${key:h}
    info "Generating $key, choose a passphrase (or leave it empty)"
    run ssh-keygen -t ed25519 -C $email -f $key
fi

# A key with a passphrase goes in the agent, with the passphrase stored in the keychain
if ssh-keygen -y -P "" -f $key >/dev/null 2>&1; then
    ok "$key has no passphrase, no need for the keychain"
elif ssh-add -l 2>/dev/null | grep -qF "$(ssh-keygen -lf $key | cut -d' ' -f2)"; then
    ok "$key is in the SSH agent"
else
    run ssh-add --apple-use-keychain $key
fi

if github_auth_ok; then
    ok "GitHub accepts $key"
    exit 0
fi
if is_dry_run; then
    info "[dry-run] would upload $key.pub to GitHub with gh"
    exit 0
fi

# Uploading a key needs the admin:public_key scope
if gh auth status -h github.com >/dev/null 2>&1; then
    run gh auth refresh -h github.com -s admin:public_key
else
    run gh auth login -h github.com -p ssh -w --skip-ssh-key -s admin:public_key
fi
run gh ssh-key add $key.pub --title "$(scutil --get ComputerName)"

if ! github_auth_ok; then
    err "GitHub still rejects $key, check https://github.com/settings/keys"
    exit 1
fi
ok "GitHub accepts $key"
