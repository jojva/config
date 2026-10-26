#!/usr/bin/env zsh
# Open a new herdr workspace running a fork of a Claude Code session, and send the fork its task.
# Usage: gork.sh <name> <session-id> < task
#   <name>        herdr workspace label, herdr agent name and the fork's session name
#   <session-id>  the Claude Code session to fork
#   task          read from stdin; when empty, the fork waits for input in its workspace

set -euo pipefail

if (( $# != 2 )); then
    print -u2 "Usage: gork.sh <name> <session-id> < task"
    exit 2
fi
name=$1 session_id=$2

if [[ ${HERDR_ENV:-} != 1 ]]; then
    print -u2 "gork: not running inside a herdr pane"
    exit 1
fi
# herdr's rule for agent names
if [[ ! $name =~ '^[a-z][a-z0-9_-]{0,31}$' ]]; then
    print -u2 "gork: invalid name '$name', it must match [a-z][a-z0-9_-]{0,31}"
    exit 2
fi
task=$(cat)

workspace=$(herdr workspace create --cwd $PWD --label $name --no-focus)
workspace_id=$(jq -r .result.workspace.workspace_id <<<$workspace)
pane_id=$(jq -r .result.root_pane.pane_id <<<$workspace)

if ! herdr agent start $name --kind claude --pane $pane_id --timeout 60000 \
    -- --resume $session_id --fork-session --name $name >/dev/null; then
    print -u2 "gork: Claude did not become ready in herdr workspace '$name' ($workspace_id), which is left open"
    exit 1
fi

if [[ -n $task ]]; then
    # The fork's transcript ends with the original session's /gork call, and holds the worktrees
    # and branches that session created: without this preamble, the fork takes them as its own.
    herdr agent prompt $name "You are a fork of Claude Code session $session_id, opened by /gork in herdr workspace '$name'. \
The /gork call that ends the conversation above belongs to the original session, which carries on with its own work: \
its worktrees and branches are not yours, so do your work in a worktree of your own.

Your task: $task" >/dev/null
fi

print "gork: forked session $session_id into herdr workspace '$name' ($workspace_id)"
