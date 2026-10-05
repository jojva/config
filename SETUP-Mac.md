# Automated setup

On a fresh Mac:
```
zsh -c "$(curl -fsSL https://raw.githubusercontent.com/jojva/config/master/mac_setup/bootstrap.sh)"
```
Then, from this repo (every step is idempotent, re-running is safe):
```
mac_setup/setup.sh                 # Run all steps
mac_setup/setup.sh <step>...       # Run only some steps
mac_setup/setup.sh --from <step>   # Resume after a failure
mac_setup/setup.sh --list          # List the steps
mac_setup/setup.sh --dry-run       # Show what would be done
```
Packages are listed in [mac_setup/Brewfile](mac_setup/Brewfile).

The first step, `prerequisites`, checks what only I can do by hand (sign in to the Apple account, add a Touch ID fingerprint): it opens the right Settings pane and waits until it's done.
The last step, `checklist`, lists what's left to do by hand afterwards (sign in to Claude Code and Firefox, fill `~/.secretsrc`...).

What follows is not automated yet.

# System

## Keyboard layout

Choose "French - PC" when I use my own keyboard and "French" when I use the built-in keyboard.

Useful: remove the backtick ` dead key: install Ukelele, copy the "French - PC" keyboard layout, and then remove the dead key.

# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import ~/workspace/AlgoliaSaaS/tools/lldb/formatters.py`
```
