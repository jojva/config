# Apps that open at login (System Settings → General → Login Items).

source ${0:A:h}/../lib.sh

apps=(
    /Applications/Doll.app
    /Applications/Dropbox.app
    /Applications/Fenetre.app
    "/Applications/Firefox algolia.app"
    "/Applications/Firefox perso.app"
    /Applications/Ghostty.app
    /Applications/Rectangle.app
    /Applications/Slack.app
    /Applications/Spotify.app
)

login_items=( "${(@f)$(osascript -e 'set text item delimiters to linefeed' \
    -e 'tell application "System Events" to get (path of every login item) as text')}" )

for app in $apps; do
    if (( ${login_items[(Ie)$app]} )); then
        ok "${app:t:r} opens at login"
    elif [[ ! -d $app ]]; then
        warn "${app:t:r} is not installed, not adding it to the login items"
    else
        run osascript -e "tell application \"System Events\" to make login item at end with properties {path:\"$app\", hidden:false}" \
            -e return
    fi
done
