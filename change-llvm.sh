#!/usr/bin/env zsh
# Upgrade local LLVM toolchain and rebuild AlgoliaSaaS.
# Usage: ./change-llvm.sh <version>   e.g. ./change-llvm.sh 21

set -eo pipefail

if [[ $# -ne 1 ]]; then
    echo "Usage: $0 <llvm-version>" >&2
    exit 1
fi

to="$1"
repo="${HOME}/workspace/AlgoliaSaaS"
zshrc="${HOME}/.zshrc"

current=$(grep -oE 'llvm@[0-9]+' "$zshrc" | head -1 | sed 's/llvm@//')
if [[ "$current" == "$to" ]]; then
    echo "Already on llvm@${to}, nothing to do."
    exit 0
fi

echo "==> Installing llvm@${to} and lld@${to} via Homebrew"
brew install "llvm@${to}" "lld@${to}"

echo "==> Updating ${zshrc}"
sed -i '' -E "s/(llvm|lld)@[0-9]+/\1@${to}/g" "$zshrc"

echo "==> Reloading shell environment"
source "$zshrc"
echo "    clang++ is now: $(which clang++)"

echo "==> Cleaning build directory"
rm -rf "${repo}/build"

echo "==> Refreshing conan profile"
source "${repo}/.venv/bin/activate"
conan config install "${repo}/tools/conan/config"

echo "==> Done. You may now source your shell configuration and rebuild AlgoliaSaaS with the new LLVM toolchain."
