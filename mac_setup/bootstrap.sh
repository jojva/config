# Bootstrap my fresh Mac: install git, clone this repo, then run the setup.
# Usage (any arguments are passed to setup.sh):
#   zsh -c "$(curl -fsSL https://raw.githubusercontent.com/jojva/config/master/mac_setup/bootstrap.sh)"

set -euo pipefail

repo_url=https://github.com/jojva/config.git
repo_dir=${CONFIG_DIR:-$HOME/workspace/config}

# git comes with the Xcode Command Line Tools
if ! xcode-select -p >/dev/null 2>&1; then
    echo "==> Installing the Xcode Command Line Tools, accept the dialog that pops up"
    xcode-select --install
    until xcode-select -p >/dev/null 2>&1; do sleep 5; done
fi

if [[ -d $repo_dir/.git ]]; then
    echo "==> $repo_dir already exists, not cloning"
else
    echo "==> Cloning $repo_url into $repo_dir"
    mkdir -p ${repo_dir:h}
    git clone $repo_url $repo_dir
fi

exec $repo_dir/mac_setup/setup.sh "$@"
