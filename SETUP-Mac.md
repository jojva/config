# System

## Startup apps

System Settings -> General -> Login Items and Extensions, add the apps:
- Dropbox
- Firefox (Pro)
- Firefox (Perso)
- Ghostty
- Slack
- Spotify

FIREFOX PRO AND PERSO HOW I DID IT

## Misc

```
# Disable annoying login message
touch ~/.hushlogin
```

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
