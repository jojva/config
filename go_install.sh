#! /bin/bash

# Installing go by following the instructions from https://go.dev/doc/install.
goversion=$(curl --silent --show-error --location https://go.dev/VERSION?m=text | rg go)
echo "Installing ${goversion}..."

# Detect OS
if [[ "$OSTYPE" == "darwin"* ]]; then
    # macOS (arm64)
    echo "Detected macOS"
    pkg_file="${goversion}.darwin-arm64.pkg"

    echo "Downloading ${pkg_file}..."
    curl --silent --show-error --location --output /tmp/"${pkg_file}" https://go.dev/dl/"${pkg_file}"

    echo "Installing Go (requires sudo)..."
    sudo installer -pkg /tmp/"${pkg_file}" -target /

    # Clean up
    rm /tmp/"${pkg_file}"
else
    # Linux
    echo "Detected Linux"
    wget -P /tmp https://go.dev/dl/"${goversion}".linux-amd64.tar.gz
    sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/"${goversion}".linux-amd64.tar.gz
fi

# New shells get it from /etc/paths.d/go (macOS) or the shell rc, but not this one
export PATH="/usr/local/go/bin:$PATH"
go version

if [[ "$OSTYPE" == "darwin"* ]]; then
    # On macOS, golangci-lint comes from Homebrew (see mac_setup/Brewfile): the install
    # script below fails its checksum check since releases ship .sbom.json files.
    echo "golangci-lint is installed by Homebrew, update it with: brew upgrade golangci-lint"
else
    # For `golangci-lint` specifically I'm using this: https://golangci-lint.run/usage/install/#linux-and-windows
    echo "Updating golangci-lint"
    curl --silent --show-error --location https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin latest
fi

echo "Done."
