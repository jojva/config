# LDAP username
export AUSER="jvalette"

# Source aliases and functions
source ~/.zsh_aliases
source ~/.zsh_functions

# Enable command auto-completion
autoload -Uz compinit && compinit

# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh)

# History configuration
export HISTSIZE=10000       # Number of commands to remember in the command history
export SAVEHIST=100000      # Number of commands to save in the history file
setopt INC_APPEND_HISTORY   # Append history immediately
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_IGNORE_DUPS     # Ignore duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicates, keep only the most recent commands
setopt HIST_IGNORE_SPACE    # Do not display commands that start with a space

# Homebrew config
export HOMEBREW_AUTO_UPDATE_SECS=86400

# AlgoliaSaaS: setup clang
export PATH="/opt/homebrew/opt/llvm@22/bin:$PATH"
export CC="/opt/homebrew/opt/llvm@22/bin/clang"
export CXX="/opt/homebrew/opt/llvm@22/bin/clang++"
export PATH="/opt/homebrew/opt/lld@22/bin:$PATH"
export LD="/opt/homebrew/opt/lld@22/bin/lld"

# Characters that are part of a word (for fast navigation).
# Default is '*?_-.[]~=/&;!#$%^(){}<>', I removed the '/' to treat paths as separate words.
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Path stuff
export PATH="$HOME/bin:$PATH"                                   # User binaries
export PATH="$HOME/go/bin:$PATH"                                # Go binaries
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"                 # PostgreSQL binaries for Metis
export PATH="$HOME/.local/bin:$PATH"                            # For Claude CLI (and maybe other binaries)
export PATH="/opt/homebrew/share/google-cloud-sdk/bin:$PATH"    # Google Cloud SDK

# Initialize Starship prompt
eval "$(starship init zsh)"

# Set AWS profile (see ~/.aws/config)
export AWS_PROFILE=metis-prod

# Go: fetch Algolia's private modules directly from GitHub (over SSH, see .gitconfig)
export GOPRIVATE="github.com/algolia/*"

# Core Vault, see https://algolia.atlassian.net/wiki/spaces/FOUNDATION/pages/5410684960
export VAULT_ADDR=https://vault.algolia.net

# Anthropic default model at startup
export ANTHROPIC_MODEL="claude-opus-5-5"

# The following lines have been added by Docker Desktop to enable Docker CLI completions.
fpath=(/Users/joris.valette/.docker/completions $fpath)
autoload -Uz compinit
(( ${+_comps[docker]} )) || compinit
# End of Docker CLI completions

# Initialize zoxide (must stay at the end, after compinit)
eval "$(zoxide init zsh)"
