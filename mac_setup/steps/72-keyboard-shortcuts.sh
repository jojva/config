# Keyboard shortcuts (System Settings → Keyboard → Keyboard Shortcuts).
# They're stored in com.apple.symbolichotkeys, by id, as (character, key code, modifiers).

source ${0:A:h}/../lib.sh

# Modifiers, and key codes from Carbon's Events.h
FN=8388608 OPTION=524288
KEY_F4=118
NO_CHAR=65535

changed=0

# ensure_hotkey <id> <description> <character> <key code> <modifiers>
ensure_hotkey() {
    local id=$1 desc=$2 expected="[$3,$4,$5]" current enabled
    current=$(defaults export com.apple.symbolichotkeys - 2>/dev/null \
        | plutil -extract AppleSymbolicHotKeys.$id.value.parameters json -o - - 2>/dev/null) || current=""
    enabled=$(defaults export com.apple.symbolichotkeys - 2>/dev/null \
        | plutil -extract AppleSymbolicHotKeys.$id.enabled raw -o - - 2>/dev/null) || enabled=""
    if [[ $current == $expected && $enabled == true ]]; then
        ok $desc
        return 0
    fi
    run defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add $id \
        "<dict><key>enabled</key><true/><key>value</key><dict><key>type</key><string>standard</string><key>parameters</key><array><integer>$3</integer><integer>$4</integer><integer>$5</integer></array></dict></dict>"
    changed=1
}

ensure_hotkey 64 "Spotlight search on F4" $NO_CHAR $KEY_F4 $FN
ensure_hotkey 65 "Finder search window on ⌥F4" $NO_CHAR $KEY_F4 $(( FN + OPTION ))

# Apply the new shortcuts without logging out
if (( changed )); then
    run /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
fi
