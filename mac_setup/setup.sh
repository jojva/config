#!/usr/bin/env zsh
# Automated macOS setup. Every step is idempotent: re-running is always safe.
#
# Usage:
#   ./setup.sh                 Run all steps
#   ./setup.sh <step>...       Run only the given steps
#   ./setup.sh --from <step>   Run from <step> to the end (e.g. to resume after a failure)
#   ./setup.sh --list          List the steps
#   ./setup.sh --dry-run ...   Show what would be done, change nothing

script=${0:A}
source ${script:h}/lib.sh

usage() {
    sed -n '4,9s/^# \{0,1\}//p' $script
}

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

for i in {1..$#steps}; do
    name=${names[i]}
    (( ${selected[(Ie)$name]} )) || continue
    log "[$name]"
    if ! zsh ${steps[i]}; then
        err "Step '$name' failed. Fix the issue, then resume with: $script --from $name"
        exit 1
    fi
done

log "Done."
