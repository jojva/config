# alcli, the PaaS team's CLI, which connects to Metis instances whether they're on
# AWS or Azure: https://github.com/algolia/alcli
# go install builds a 0.0.0 version, which alcli update replaces with the latest
# release. alcli needs GITHUB_PAT on every run: it's kept in 1Password.

source ${0:A:h}/../lib.sh

alcli=~/go/bin/alcli
config=~/.alcli/config.yml
token_url="https://github.com/settings/personal-access-tokens/16352133"
new_token_url="https://github.com/settings/personal-access-tokens/new"

require_secret GITHUB_PAT "op://Employee/GitHub token - alcli/credential" \
    "alcli needs a GitHub token, on every run (.zshrc's alcli function reads it too)." \
    "Regenerate it at $token_url, or if that page doesn't exist anymore, create one at" \
    "$new_token_url with: Token name alcli, Resource owner algolia, Expiration 365 days," \
    "Only select repositories AlgoliaSaaS, go, metis, python, ultra, metis-deployments," \
    "metis-release-manager and alcli, Repository permissions Contents read-only," \
    "Actions read and write, Pull requests read-only." \
    "Save it in 1Password: API Credential \"GitHub token - alcli\" in the Employee vault."

if [[ -x $alcli ]]; then
    ok "alcli installed"
else
    run env GOPRIVATE='github.com/algolia/*' go install github.com/algolia/alcli@latest
fi

# alcli update needs the config created by alcli init
if [[ -f $config ]]; then
    ok "$config exists"
elif is_dry_run; then
    info "[dry-run] would run alcli init"
else
    info "Choose the Dev profile: ProdEng is for Production Engineering, Engines is part of R&D"
    run $alcli init </dev/tty
fi

# The version built by go install is 0.0.0
if [[ $($alcli version 2>/dev/null) == 0.0.0* ]]; then
    run $alcli update
else
    ok "alcli $($alcli version 2>/dev/null | cut -d' ' -f1)"
fi
