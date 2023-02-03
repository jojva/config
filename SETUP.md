# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import /home/joris/workspace/a/tools/lldb/formatters.py`
subl /etc/sysctl.d/10-ptrace.conf # and replace "kernel.yama.ptrace_scope = 1" with "kernel.yama.ptrace_scope = 0"
```

# Ubuntu

```
# Disable APT news https://askubuntu.com/questions/1441035/what-is-meant-by-apt-news
sudo pro config set apt_news=false

# Install necessary packages
sudo apt install pssh
```
