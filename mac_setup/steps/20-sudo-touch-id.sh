# Use Touch ID for sudo. Unlike /etc/pam.d/sudo, sudo_local survives macOS updates.
# Note: doesn't work inside tmux without pam-reattach.

source ${0:A:h}/../lib.sh

file=/etc/pam.d/sudo_local
line='auth       sufficient     pam_tid.so'

if grep -qE '^[[:space:]]*auth[[:space:]]+sufficient[[:space:]]+pam_tid\.so' $file 2>/dev/null; then
    ok "Touch ID enabled for sudo"
else
    run sudo zsh -c "print -r -- '$line' >> $file"
fi
