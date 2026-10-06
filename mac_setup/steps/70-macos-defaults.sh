# macOS settings that can be set from the command line.

source ${0:A:h}/../lib.sh

# Dock: on the left, hidden by default
ensure_default com.apple.dock orientation string left
ensure_default com.apple.dock autohide bool true

# Disable natural scrolling (applies after logging out)
ensure_default NSGlobalDomain com.apple.swipescrolldirection bool false

# Mute the alert sound ("bloup" when the terminal does something impossible)
ensure_default NSGlobalDomain com.apple.sound.beep.volume float 0

# Finder: show file extensions and the path bar
ensure_default NSGlobalDomain AppleShowAllExtensions bool true
ensure_default com.apple.finder ShowPathbar bool true

# Show ~/Library in Finder
if [[ $(ls -lOd ~/Library) == *hidden* ]]; then
    run chflags nohidden ~/Library
else
    ok "~/Library is visible"
fi

# Screenshots go to their own folder instead of the Desktop
screenshots=~/Screenshots
[[ -d $screenshots ]] || run mkdir -p $screenshots
ensure_default com.apple.screencapture location string $screenshots

# Mute the startup chime
if [[ $(nvram StartupMute 2>/dev/null) == *%01 ]]; then
    ok "Startup chime muted"
else
    run sudo nvram StartupMute=%01
fi

# Disable the "Last login" message in new terminals
if [[ -e ~/.hushlogin ]]; then
    ok "~/.hushlogin exists"
else
    run touch ~/.hushlogin
fi

if (( ${CHANGED_DOMAINS[(Ie)com.apple.dock]} )); then
    run killall Dock
fi
if (( ${CHANGED_DOMAINS[(Ie)com.apple.finder]} || ${CHANGED_DOMAINS[(Ie)NSGlobalDomain]} )); then
    run killall Finder
fi
if (( ${CHANGED_DOMAINS[(Ie)com.apple.screencapture]} )); then
    run killall SystemUIServer
fi
if (( ${CHANGED_KEYS[(Ie)NSGlobalDomain com.apple.swipescrolldirection]} || ${CHANGED_KEYS[(Ie)NSGlobalDomain com.apple.sound.beep.volume]} )); then
    warn "Log out and back in to apply the scrolling and alert sound settings"
fi
