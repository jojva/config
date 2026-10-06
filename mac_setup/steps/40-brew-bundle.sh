# Install the packages listed in the Brewfile.
# Already installed packages are not upgraded: setting up is not updating.

source ${0:A:h}/../lib.sh

brewfile=$SETUP_DIR/Brewfile

# Formulae of the Brewfile that come from third-party taps
ensure_brew_trust azure/kubelogin/kubelogin
ensure_brew_trust hashicorp/tap/vault

if brew bundle check --file=$brewfile --no-upgrade >/dev/null 2>&1; then
    ok "All Brewfile packages are installed"
    exit 0
fi

run brew bundle install --file=$brewfile --no-upgrade
