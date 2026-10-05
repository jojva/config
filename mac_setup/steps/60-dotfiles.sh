# Symlink the dotfiles from this repo, so that editing them edits the repo.
# Existing files are moved aside first, as <file>.backup-<date>.

source ${0:A:h}/../lib.sh

ensure_symlink $REPO_DIR/common_dotfiles/.bash_aliases ~/.bash_aliases
ensure_symlink $REPO_DIR/common_dotfiles/.gitconfig ~/.gitconfig
ensure_symlink $REPO_DIR/mac_dotfiles/.zprofile ~/.zprofile
ensure_symlink $REPO_DIR/mac_dotfiles/.zshrc ~/.zshrc
ensure_symlink $REPO_DIR/mac_dotfiles/.ssh/config ~/.ssh/config

# Secrets sourced by .zshrc, kept out of the repo
if [[ -e ~/.secretsrc ]]; then
    ok "~/.secretsrc exists"
elif is_dry_run; then
    info "[dry-run] would create an empty ~/.secretsrc"
else
    print '# Secrets sourced by ~/.zshrc (not versioned), e.g. export SOME_TOKEN=...' > ~/.secretsrc
    chmod 600 ~/.secretsrc
    ok "Created an empty ~/.secretsrc"
fi
