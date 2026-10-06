# Python, managed by uv, as the default python/python3 (in ~/.local/bin, which
# comes before Homebrew in the PATH). Homebrew's own python is only a dependency
# (of gcloud-cli), and projects get the version they ask for through uv anyway.
# An installed Python isn't upgraded: use `uv python upgrade` for that.

source ${0:A:h}/../lib.sh

python=~/.local/bin/python3

if [[ -x $python && $(readlink $python) == $(uv python dir)/* ]]; then
    ok "$($python --version) installed by uv"
    exit 0
fi

# --default is still a preview feature of uv
run uv python install --default --preview-features python-install-default
