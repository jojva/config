# Go, installed by go_install.sh (which also updates it when run by hand).
# golangci-lint comes from the Brewfile.

source ${0:A:h}/../lib.sh

go=/usr/local/go/bin/go

if [[ -x $go ]]; then
    ok "$($go version | cut -d' ' -f3) installed"
    exit 0
fi

run bash $REPO_DIR/go_install.sh

# go_install.sh doesn't stop on errors, check that it worked
if ! is_dry_run && [[ ! -x $go ]]; then
    err "go_install.sh didn't install Go, see its output above"
    exit 1
fi
