# Shared helpers, sourced by setup.sh and by every step.
# Steps must be idempotent: check the current state first, act only if needed.

set -euo pipefail

SETUP_DIR=${${(%):-%x}:A:h}
REPO_DIR=${SETUP_DIR:h}
DRY_RUN=${DRY_RUN:-0}

# Algolia repos go in ~/workspace, every other git clone (personal tools,
# third-party sources...) goes in ~/dev.
WORKSPACE_DIR=$HOME/workspace
DEV_DIR=$HOME/dev

# Make Homebrew available in every step, even right after its installation.
if [[ -x /opt/homebrew/bin/brew ]]; then
    eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Logging
log()  { print -r -- $'\e[1;34m==>\e[0m \e[1m'"$*"$'\e[0m' }
info() { print -r -- "    $*" }
ok()   { print -r -- $'    \e[32m✓\e[0m '"$*" }
warn() { print -r -- $'    \e[33m!\e[0m '"$*" >&2 }
err()  { print -r -- $'\e[1;31mError:\e[0m '"$*" >&2 }

is_dry_run() { (( DRY_RUN )) }

# Print a command, then run it (or only print it in dry-run mode).
run() {
    if is_dry_run; then
        print -r -- "    [dry-run] ${(q-)@}"
    else
        print -r -- $'    \e[2m$ '"${(q-)@}"$'\e[0m'
        "$@"
    fi
}

# ensure_clone <url> <dir>
# Clones a repo with its submodules, unless it's already there (an existing clone
# is not updated).
ensure_clone() {
    local url=$1 dir=$2
    if [[ -d $dir/.git ]]; then
        ok "$dir already cloned"
        return 0
    fi
    [[ -d ${dir:h} ]] || run mkdir -p ${dir:h}
    run git clone --recurse-submodules $url $dir
}

# ensure_symlink <target> <link>
# Makes <link> a symlink to <target>. Anything already at <link> is moved aside.
ensure_symlink() {
    local target=$1 link=$2
    if [[ -L $link && $(readlink $link) == $target ]]; then
        ok "$link → $target"
        return 0
    fi
    [[ -d ${link:h} ]] || run mkdir -p ${link:h}
    if [[ -e $link || -L $link ]]; then
        run mv $link $link.backup-$(date +%Y%m%d-%H%M%S)
    fi
    run ln -s $target $link
}

# ensure_default <domain> <key> <bool|int|float|string> <value>
# Writes a `defaults` value only when it differs from the current one.
# Appends the domain to CHANGED_DOMAINS when something was written.
typeset -ga CHANGED_DOMAINS
ensure_default() {
    local domain=$1 key=$2 type=$3 value=$4 expected current
    case $type in
        bool)  [[ $value == true ]] && expected=1 || expected=0 ;;
        *)     expected=$value ;;
    esac
    current=$(defaults read "$domain" "$key" 2>/dev/null) || current=""
    if [[ $current == "$expected" ]] || { [[ $type == (int|float) && -n $current ]] && (( current == expected )) }; then
        ok "$domain $key = $value"
        return 0
    fi
    run defaults write "$domain" "$key" "-$type" "$value"
    CHANGED_DOMAINS+=($domain)
}
