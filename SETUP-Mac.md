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

What follows is not automated yet.

# System

## Keyboard layout

Choose "French - PC" when I use my own keyboard and "French" when I use the built-in keyboard.

Useful: remove the backtick ` dead key: install Ukelele, copy the "French - PC" keyboard layout, and then remove the dead key.

## Misc

Remap alt-tab through windows to ⌘ + @ instead of ⌘ + `:
System Settings → Keyboard → Keyboard Shortcuts → Keyboard → Move focus to next window → remap to ⌘ + @.

# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import ~/workspace/AlgoliaSaaS/tools/lldb/formatters.py`
```

# Firefox

The `algolia` and `perso` profiles and their launcher apps are created by the `firefox-profiles` step.
Then sign in to each profile: the passwords are stored in Firefox, get them from my phone, in the matching profile.
To restore my tabs, open about:firefoxview, which lists the tabs open on my other devices.

# Go

See [go_install.sh](go_install.sh).
