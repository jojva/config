# Two Firefox profiles, algolia and perso, each with its own launcher app.

source ${0:A:h}/../lib.sh

firefox=/Applications/Firefox.app/Contents/MacOS/firefox
profiles_ini=~/Library/Application\ Support/Firefox/profiles.ini

for profile in algolia perso; do
    if grep -qx "Name=$profile" $profiles_ini 2>/dev/null; then
        ok "Firefox profile $profile exists"
    else
        run $firefox -CreateProfile $profile
    fi

    app="/Applications/Firefox $profile.app"
    if [[ -d $app ]]; then
        ok "$app exists"
    else
        run osacompile -o $app -e "do shell script \"open -na Firefox --args -P $profile\""
    fi
done
