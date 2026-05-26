# System

## Keyboard layout

Choose "French - PC" when I use my own keyboard and "French" when I use the built-in keyboard.

Useful: remove the backtick ` dead key: install Ukelele, copy the "French - PC" keyboard layout, and then remove the dead key.

## Useful packages

```
brew install --cask
  alt-tab \
  dropbox \
  firefox \
  ghostty \
  slack \
  spotify
```

Configure alt-tab (the app) to use ⌘ and not ⌥.

Also install doll (https://github.com/xiaogdgenuine/Doll) to see Slack notifs in the menu bar.

## Startup apps

System Settings -> General -> Login Items and Extensions, add the apps:
- Dropbox
- Firefox (Pro)
- Firefox (Perso)
- Ghostty
- Slack
- Spotify

## Misc

```
# Disable annoying login message
touch ~/.hushlogin
```

Remap alt-tab through windows to ⌘ + @ instead of ⌘ + `:
System Settings → Keyboard → Keyboard Shortcuts → Keyboard → Move focus to next window → remap to ⌘ + @.

# AlgoliaSaaS

```bash
mkdir .vscode && cp -r tools/environments/*.json .vscode/
cp tools/lldb/lldbinit.sample ~/.lldbinit
subl ~/.lldbinit # -> replace with `command script import ~/workspace/AlgoliaSaaS/tools/lldb/formatters.py`
```

# Firefox

For the pro and perso profiles, I used the Automator.

Automator -> New Document -> Application -> "Run Shell Script" ->
- Pro -> `/Applications/Firefox.app/Contents/MacOS/firefox -P "pro" --no-remote`
- Perso -> `/Applications/Firefox.app/Contents/MacOS/firefox -P "perso" --no-remote`

# Go

See [go_install.sh](go_install.sh).
