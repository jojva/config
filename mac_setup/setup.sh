#!/usr/bin/env zsh
# Automated macOS setup. Every step is idempotent: re-running is always safe.
#
# Usage:
#   ./setup.sh                 Run all steps
#   ./setup.sh <step>...       Run only the given steps
#   ./setup.sh --from <step>   Run from <step> to the end (e.g. to resume after a failure)
#   ./setup.sh --list          List the steps
#   ./setup.sh --dry-run ...   Show what would be done, change nothing
#
# After a step that changed something or asked me something, it waits for my
# confirmation before going on with the next one.

script=${0:A}
source ${script:h}/lib.sh

usage() {
    sed -n '4,9s/^# \{0,1\}//p' $script
}

# Steps run in file name order. The tens digit is the phase: 1 macOS basics,
# 2 packages, 3 browser, keys and dotfiles, 4 work access, 5 settings and apps,
# 6 wrap-up.
steps=( $SETUP_DIR/steps/*.sh(N) )
step_name() { local n=${1:t:r}; print -r -- ${n#<->-} }
names=()
for f in $steps; do names+=($(step_name $f)); done

selected=()
from=""
while (( $# )); do
    case $1 in
        -h|--help) usage; exit 0 ;;
        -l|--list) print -l -- $names; exit 0 ;;
        -n|--dry-run) DRY_RUN=1 ;;
        --from) from=${2:-}; [[ -n $from ]] || { err "--from requires a step name"; exit 1 }; shift ;;
        -*) err "Unknown option: $1"; usage; exit 1 ;;
        *) selected+=($1) ;;
    esac
    shift
done

for s in $selected $from; do
    (( ${names[(Ie)$s]} )) || { err "Unknown step: $s (see --list)"; exit 1 }
done
if [[ -n $from ]] && (( $#selected )); then
    err "--from and explicit steps are mutually exclusive"
    exit 1
fi

if [[ $(uname -s) != Darwin || $(uname -m) != arm64 ]]; then
    err "This setup only supports macOS on Apple Silicon"
    exit 1
fi
if (( EUID == 0 )); then
    err "Don't run this as root, steps call sudo themselves when needed"
    exit 1
fi

if [[ -n $from ]]; then
    selected=( ${names[${names[(ie)$from]},-1]} )
elif (( ! $#selected )); then
    selected=( $names )
fi

export DRY_RUN
if is_dry_run; then
    log "Dry run: nothing will be changed"
fi

# Steps record their changes in this file (see mark_changed): after a step that
# changed something or asked me something, wait for my confirmation.
export SETUP_CHANGES_FILE=$(mktemp -t mac_setup)
trap 'rm -f $SETUP_CHANGES_FILE' EXIT

todo=()
for i in {1..$#steps}; do
    if (( ${selected[(Ie)${names[i]}]} )); then
        todo+=($i)
    fi
done

for (( n = 1; n <= $#todo; n++ )); do
    i=$todo[n]
    name=$names[i]
    log "[$name]"
    : > $SETUP_CHANGES_FILE
    if ! zsh $steps[i]; then
        err "Step '$name' failed. Fix the issue, then resume with: $script --from $name"
        exit 1
    fi
    if (( n < $#todo )) && [[ -s $SETUP_CHANGES_FILE ]]; then
        next=$names[$todo[n+1]]
        if ! read -r "answer?    '$name' changed things: press Enter to go on with '$next', or q to stop: " </dev/tty; then
            err "No terminal to confirm, stopping. Resume with: $script --from $next"
            exit 1
        fi
        if [[ $answer == q ]]; then
            log "Stopped. Resume with: $script --from $next"
            exit 0
        fi
    fi
done

log "Done."
