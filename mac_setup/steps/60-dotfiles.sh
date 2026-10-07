# Symlink the dotfiles from this repo, so that editing them edits the repo.
# Existing files are moved aside first, as <file>.backup-<date>.

source ${0:A:h}/../lib.sh

ensure_symlink $REPO_DIR/common_dotfiles/.bash_aliases ~/.bash_aliases
ensure_symlink $REPO_DIR/common_dotfiles/.gitconfig ~/.gitconfig
ensure_symlink $REPO_DIR/common_dotfiles/AGENTS.md ~/.codex/AGENTS.md
ensure_symlink $REPO_DIR/common_dotfiles/AGENTS.md ~/.claude/CLAUDE.md
ensure_symlink $REPO_DIR/mac_dotfiles/.zprofile ~/.zprofile
ensure_symlink $REPO_DIR/mac_dotfiles/.zshrc ~/.zshrc
ensure_symlink $REPO_DIR/mac_dotfiles/.config/ghostty/config.ghostty ~/.config/ghostty/config.ghostty
ensure_symlink $REPO_DIR/mac_dotfiles/.ssh/config ~/.ssh/config
