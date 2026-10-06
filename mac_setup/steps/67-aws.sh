# AWS SSO profiles for Metis, which alcli's Dev profile uses: metis-dev (test
# instances) and metis-prod (stage and prod). They're not versioned, as they hold
# internal identifiers (SSO URL, account IDs) and this repo is public: they're
# pasted from the AWS User Guide. Logging in stays daily: aws sso login.

source ${0:A:h}/../lib.sh

guide_url="https://algolia.atlassian.net/wiki/spaces/TTPB/pages/4612030465/AWS+User+Guide#Configuration"
profiles=(metis-dev metis-prod)

missing_profiles() {
    local existing=( ${(f)"$(aws configure list-profiles 2>/dev/null)"} )
    print -l -- ${profiles:|existing}
}

missing=( $(missing_profiles) )
if (( ! $#missing )); then
    ok "AWS profiles ${(j:, :)profiles} exist"
    exit 0
fi
if is_dry_run; then
    info "[dry-run] would ask to add the AWS profiles ${(j:, :)missing}"
    exit 0
fi

[[ -d ~/.aws ]] || run mkdir ~/.aws
info "Copy the [profile ${(j:] and [profile :)missing}] sections from the AWS User Guide"
info "that opens (CLI → Configuration) into ~/.aws/config"
open_work_url $guide_url
ask -r "?    Press Enter once ~/.aws/config is saved: "

missing=( $(missing_profiles) )
if (( $#missing )); then
    err "Still missing in ~/.aws/config: ${(j:, :)missing}"
    exit 1
fi
ok "AWS profiles ${(j:, :)profiles} exist, log in with: aws sso login --profile metis-dev"
