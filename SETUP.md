# Ubuntu

## Startup apps

To have startup applications ready, copy `autostart` folder into ~/.config/autostart.

## Misc

```
# Disable APT news https://askubuntu.com/questions/1441035/what-is-meant-by-apt-news
sudo pro config set apt_news=false

# Install necessary packages
sudo apt install pssh
```

# Python

Use `pyenv` to install specific versions in specific folders.
```
# Install the wanted version
pyenv install 3.10
# Make it the version of the current folder (don't use `pyenv global`!)
pyenv local 3.10
```

# Go

Follow instructions here https://go.dev/doc/install but replace `/usr/local/...` by `~/...`
```bash
goversion=1.20.4
wget https://go.dev/dl/go${goversion}.linux-amd64.tar.gz
sudo rm -rf ~/go && tar -C ~ -xzf go${goversion}.linux-amd64.tar.gz
go version
```

For `golangci-lint` specifically I'm using this: https://golangci-lint.run/usage/install/#linux-and-windows
```bash
curl -sSfL https://raw.githubusercontent.com/golangci/golangci-lint/master/install.sh | sh -s -- -b $(go env GOPATH)/bin latest
```

# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import /home/joris/workspace/a/tools/lldb/formatters.py`
subl /etc/sysctl.d/10-ptrace.conf # and replace "kernel.yama.ptrace_scope = 1" with "kernel.yama.ptrace_scope = 0"
```
