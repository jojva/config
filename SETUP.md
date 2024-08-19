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

See [go_install.sh](go_install.sh).

# Node

For the version manager I use [fnm](https://github.com/Schniz/fnm).

```bash
# Install fnm
curl -fsSL https://fnm.vercel.app/install | bash
# Update fnm
curl -fsSL https://fnm.vercel.app/install | bash --skip-shell
# Remove fnm
rm -rf ~/.fnm
# Shell setup, add this to ~/.bashrc:
eval "$(fnm env --use-on-cd)"
```

# Yarn

```bash
# Install or update (once I've installed npm, which is automatically installed by fnm)
npm install --global yarn
```

# k6 (k9 load testing)

Installed by following the instructions here: https://k6.io/docs/get-started/installation/.

```bash
sudo gpg -k
sudo gpg --no-default-keyring --keyring /usr/share/keyrings/k6-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys C5AD17C747E3415A3642D57D77C6C491D6AC1D69
echo "deb [signed-by=/usr/share/keyrings/k6-archive-keyring.gpg] https://dl.k6.io/deb stable main" | sudo tee /etc/apt/sources.list.d/k6.list
sudo apt-get update
sudo apt-get install k6
```

# Docker

Installed via the convenience script:
```bash
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
```

# AWS CLI

Installed by following the instructions here: https://algolia.atlassian.net/wiki/spaces/TTPB/pages/4612030465/AWS+User+Guide#CLI

# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import /home/joris/workspace/a/tools/lldb/formatters.py`
subl /etc/sysctl.d/10-ptrace.conf # and replace "kernel.yama.ptrace_scope = 1" with "kernel.yama.ptrace_scope = 0"
```
