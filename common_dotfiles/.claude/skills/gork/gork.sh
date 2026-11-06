#!/usr/bin/env zsh
# Open a new herdr workspace (herdr TUI) or Herdr space (Herdr app) running a fork of a Claude Code
# session, and send the fork its task.
# Usage: gork.sh <name> <session-id> < task
#   <name>        workspace or space label, herdr agent name and the fork's session name
#   <session-id>  the Claude Code session to fork
#   task          read from stdin; when empty, the fork waits for input in its workspace

set -euo pipefail

if (( $# != 2 )); then
    print -u2 "Usage: gork.sh <name> <session-id> < task"
    exit 2
fi
name=$1 session_id=$2

# Check the TUI first: a herdr TUI started in a Herdr app terminal inherits HC_TERMINAL_ID.
if [[ ${HERDR_ENV:-} == 1 ]]; then
    backend=tui where="herdr workspace '$name'"
elif [[ -n ${HC_TERMINAL_ID:-} ]]; then
    backend=app where="Herdr space '$name'"
else
    print -u2 "gork: not running inside a herdr TUI pane or a Herdr app terminal"
    exit 1
fi
# herdr's rule for agent names
if [[ ! $name =~ '^[a-z][a-z0-9_-]{0,31}$' ]]; then
    print -u2 "gork: invalid name '$name', it must match [a-z][a-z0-9_-]{0,31}"
    exit 2
fi
task=$(cat)

prompt=
if [[ -n $task ]]; then
    # The fork's transcript ends with the original session's /gork call, and holds the worktrees
    # and branches that session created: without this preamble, the fork takes them as its own.
    prompt="You are a fork of Claude Code session $session_id, opened by /gork in $where. \
The /gork call that ends the conversation above belongs to the original session, which carries on with its own work: \
its worktrees and branches are not yours, so do your work in a worktree of your own.

Your task: $task"
fi

if [[ $backend == tui ]]; then
    workspace=$(herdr workspace create --cwd $PWD --label $name --no-focus)
    workspace_id=$(jq -r .result.workspace.workspace_id <<<$workspace)
    pane_id=$(jq -r .result.root_pane.pane_id <<<$workspace)

    if ! herdr agent start $name --kind claude --pane $pane_id --timeout 60000 \
        -- --resume $session_id --fork-session --name $name >/dev/null; then
        print -u2 "gork: Claude did not become ready in $where ($workspace_id), which is left open"
        exit 1
    fi
    if [[ -n $prompt ]]; then
        herdr agent prompt $name $prompt >/dev/null
    fi
    print "gork: forked session $session_id into $where ($workspace_id)"
    exit 0
fi

# The app shows a new space at once: switch back to the space of this terminal afterwards.
original_space=$(herdr-app ls | jq -r --arg t $HC_TERMINAL_ID \
    '.spaces[] | select(any(.tabs[].terminals[]; .terminal == $t)) | .id')
# The app waits for Claude to be ready before it sends the task.
args=$(jq -n --arg name $name --arg folder $PWD --arg session $session_id --arg task $prompt '
    {name: $name, folder: $folder,
     argv: ["claude", "--resume", $session, "--fork-session", "--name", $name]}
    + if $task == "" then {} else {task: $task} end')
if ! space=$(herdr-app do space.new $args); then
    print -u2 "gork: could not open $where: $space"
    exit 1
fi
if [[ -n $original_space ]]; then
    herdr-app do space.select --id $original_space >/dev/null
fi
print "gork: forked session $session_id into $where (terminal $(jq -r .terminal <<<$space))"
