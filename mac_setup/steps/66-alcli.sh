# alcli, the PaaS team's CLI, which connects to Metis instances whether they're on
# AWS or Azure: https://github.com/algolia/alcli
# go install builds a 0.0.0 version, which alcli update replaces with the latest
# release. alcli needs GITHUB_PAT on every run, so it's exported in ~/.secretsrc.

source ${0:A:h}/../lib.sh

alcli=~/go/bin/alcli
config=~/.alcli/config.yml
token_url="https://github.com/settings/personal-access-tokens/16352133"
new_token_url="https://github.com/settings/personal-access-tokens/new"

if [[ -n ${GITHUB_PAT:-} ]]; then
    ok "GITHUB_PAT is set"
elif is_dry_run; then
    info "[dry-run] would ask for the GITHUB_PAT token"
else
    info "alcli needs a GitHub token in GITHUB_PAT, on every run."
    info "Regenerate the existing token in the page that opens: $token_url"
    info "If that page doesn't exist anymore, create a new one at $new_token_url with:"
    info "  Token name: alcli"
    info "  Resource owner: algolia"
    info "  Expiration: 365 days"
    info "  Repository access: Only select repositories, AlgoliaSaaS, go, metis, python, ultra,"
    info "  metis-deployments, metis-release-manager and alcli"
    info "  Repository permissions: Contents read-only, Actions read and write, Pull requests read-only"
    info "Whether you regenerate it or create a new one, export it as GITHUB_PAT in ~/.secretsrc,"
    info "then paste it below too."
    open_work_url $token_url
    ask -rs "token?    Please also paste the token here: "
    print
    export GITHUB_PAT=$token
    unset token
fi

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
