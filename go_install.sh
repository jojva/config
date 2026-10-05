#! /bin/bash
# Install or update Go and golangci-lint on Linux.
# On macOS, both come from Homebrew (see mac_setup/Brewfile).

if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "On macOS, Go and golangci-lint come from Homebrew: brew upgrade go golangci-lint" >&2
    exit 1
fi

# Installing go by following the instructions from https://go.dev/doc/install.
goversion=$(curl --silent --show-error --location https://go.dev/VERSION?m=text | rg go)
echo "Installing ${goversion}..."
wget -P /tmp https://go.dev/dl/"${goversion}".linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/"${goversion}".linux-amd64.tar.gz

# New shells get it from the shell rc, but not this one
export PATH="/usr/local/go/bin:$PATH"
go version

# For `golangci-lint` specifically I'm using this: https://golangci-lint.run/usage/install/#linux-and-windows
echo "Updating golangci-lint"
curl --silent --show-error --location https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin latest

echo "Done."
