# fenêtre, my window switcher: https://github.com/jojva/fenetre

source ${0:A:h}/../lib.sh

repo=$DEV_DIR/fenetre
app=/Applications/Fenetre.app
cert=fenetre-dev
keychain=~/Library/Keychains/login.keychain-db

# The Makefile signs with a self-signed certificate, so that the Accessibility
# permission survives rebuilds. codesign only accepts it once it's trusted for
# code signing, which needs the user's password (macOS shows a dialog).
if security find-identity -v -p codesigning | grep -q "\"$cert\""; then
    ok "Code-signing certificate $cert exists"
elif is_dry_run; then
    info "[dry-run] would create and trust the $cert code-signing certificate"
else
    tmp=$(mktemp -d)
    trap 'rm -rf $tmp' EXIT
    if security find-certificate -c $cert $keychain >/dev/null 2>&1; then
        # Imported by a previous run that was interrupted before trusting it
        security find-certificate -c $cert -p $keychain > $tmp/cert.pem
    else
        info "Creating the $cert certificate"
        print -l '[req]' 'distinguished_name = dn' 'x509_extensions = ext' 'prompt = no' \
            '[dn]' "CN = $cert" \
            '[ext]' 'basicConstraints = critical,CA:false' 'keyUsage = critical,digitalSignature' \
            'extendedKeyUsage = critical,codeSigning' > $tmp/req.cnf
        openssl req -x509 -newkey rsa:2048 -nodes -days 3650 -config $tmp/req.cnf \
            -keyout $tmp/key.pem -out $tmp/cert.pem 2>/dev/null
        openssl pkcs12 -export -inkey $tmp/key.pem -in $tmp/cert.pem -name $cert \
            -passout pass:tmp -out $tmp/cert.p12
        run security import $tmp/cert.p12 -k $keychain -P tmp -T /usr/bin/codesign
    fi
    info "Trusting $cert for code signing: enter your password in the macOS dialog"
    run security add-trusted-cert -r trustRoot -p codeSign -k $keychain $tmp/cert.pem
fi

ensure_clone https://github.com/jojva/fenetre.git $repo

if [[ -d $app ]]; then
    ok "$app installed"
else
    run make -C $repo install CONFIG=release
    run open $app
    warn "Grant fenêtre the Accessibility permission when asked"
    warn "(System Settings → Privacy & Security → Accessibility)"
fi
