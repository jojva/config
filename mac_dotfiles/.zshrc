# LDAP username
export AUSER="jvalette"

# Source bash aliases
source ~/.bash_aliases

# Source secrets
source ~/.secretsrc

# Enable command auto-completion
autoload -Uz compinit && compinit

# History configuration
export HISTSIZE=10000       # Number of commands to remember in the command history
export SAVEHIST=100000      # Number of commands to save in the history file
setopt INC_APPEND_HISTORY   # Append history immediately
setopt SHARE_HISTORY        # Share history between sessions
setopt HIST_IGNORE_DUPS     # Ignore duplicate commands in history
setopt HIST_IGNORE_ALL_DUPS # Remove older duplicates, keep only the most recent commands
setopt HIST_IGNORE_SPACE    # Do not display commands that start with a space

# AlgoliaSaaS: setup clang
export PATH="/opt/homebrew/opt/llvm@20/bin:$PATH"
export CC="/opt/homebrew/opt/llvm@20/bin/clang"
export CXX="/opt/homebrew/opt/llvm@20/bin/clang++"
export PATH="/opt/homebrew/opt/lld@20/bin:$PATH"
export LD="/opt/homebrew/opt/lld@20/bin/lld"

# Characters that are part of a word (for fast navigation).
# Default is '*?_-.[]~=/&;!#$%^(){}<>', I removed the '/' to treat paths as separate words.
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Path stuff
export PATH="$HOME/bin:$PATH"       # User binaries
export PATH="$HOME/go/bin:$PATH"    # Go binaries

# Initialize Starship prompt
eval "$(starship init zsh)"
