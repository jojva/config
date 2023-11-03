#! /bin/bash

# Installing go by following the instructions from https://go.dev/doc/install.
goversion=$(curl --silent --show-error --location https://go.dev/VERSION?m=text | rg go)
echo "Installing ${goversion}..."
wget -P /tmp https://go.dev/dl/"${goversion}".linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf /tmp/"${goversion}".linux-amd64.tar.gz
go version

# For `golangci-lint` specifically I'm using this: https://golangci-lint.run/usage/install/#linux-and-windows
echo "Updating golangci-lint"
curl --silent --show-error --location https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b "$(go env GOPATH)"/bin latest

echo "Done."
