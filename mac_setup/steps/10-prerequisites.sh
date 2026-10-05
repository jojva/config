# Things only I can do by hand, needed before the rest of the setup.
# Each one is checked: if it's missing, the right Settings pane opens and the step
# waits until it's done.

source ${0:A:h}/../lib.sh

apple_account_ok() {
    defaults read MobileMeAccounts Accounts 2>/dev/null | grep -q AccountID
}

fingerprint_ok() {
    local count=$(bioutil -c 2>/dev/null | awk '/biometric/{print $3}')
    (( ${count:-0} > 0 ))
}

# require <description> <check function> <Settings pane URL>
require() {
    local desc=$1 check=$2 pane=$3 answer
    if $check; then
        ok $desc
        return 0
    fi
    if is_dry_run; then
        info "[dry-run] would ask you to: $desc"
        return 0
    fi
    warn "To do: $desc"
    open $pane
    until $check; do
        read -r "answer?    Press Enter once done (or type 'skip'): " </dev/tty
        if [[ $answer == skip ]]; then
            warn "Skipped: $desc"
            return 0
        fi
    done
    ok $desc
}

require "Sign in to the Apple account" apple_account_ok \
    "x-apple.systempreferences:com.apple.systempreferences.AppleIDSettings"
require "Add a fingerprint to Touch ID" fingerprint_ok \
    "x-apple.systempreferences:com.apple.Touch-ID-Settings.extension"
