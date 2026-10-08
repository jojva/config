# Install Homebrew (which also installs the Xcode Command Line Tools if needed).

source ${0:A:h}/../lib.sh

if [[ -x /opt/homebrew/bin/brew ]]; then
    ok "Homebrew already installed ($(brew --version | head -1))"
    exit 0
fi

if is_dry_run; then
    info "[dry-run] would install Homebrew"
    exit 0
fi

# The installer needs sudo, ask for the password upfront so it can run non-interactively.
mark_changed
sudo -v
NONINTERACTIVE=1 /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ok "Homebrew installed"
