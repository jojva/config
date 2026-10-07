# 1Password: the app (installed by Self Service), its CLI integration for op (in
# the Brewfile), and its SSH agent.

source ${0:A:h}/../lib.sh

app=/Applications/1Password.app
agent_socket=~/Library/Group\ Containers/2BUA8C4S2C.com.1password/t/agent.sock

app_installed() { [[ -d $app ]] }

cli_integrated() {
    local accounts
    accounts=$(op account list --format=json 2>/dev/null) || return 1
    [[ -n $accounts && $accounts != "[]" ]]
}

# ssh-add -l exits with 1 when the agent answers without keys, 2 when it doesn't answer
ssh_agent_on() {
    local code=0
    SSH_AUTH_SOCK=$agent_socket ssh-add -l >/dev/null 2>&1 || code=$?
    (( code != 2 ))
}

require "Install 1Password from Algolia Self Service, then sign in" app_installed \
    "/Applications/Algolia Self Service.app"
require "Turn on 1Password → Settings → Developer → Integrate with 1Password CLI" cli_integrated $app
require "Turn on 1Password → Settings → Developer → Use the SSH agent" ssh_agent_on $app
