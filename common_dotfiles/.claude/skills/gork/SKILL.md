---
name: gork
description: Fork this Claude Code session into a new herdr workspace and hand the fork a task, such as fixing a bug found along the way, while this session carries on. Use only when the user types /gork or asks to gork something.
argument-hint: "[task for the fork]"
---

Fork this session into a new herdr workspace. The fork starts with this whole conversation, then works on its task on its own while this session carries on with the current work.

The fork's task, as the user wrote it: $ARGUMENTS

1. Pick a name for the fork: a short kebab-case summary of the task that matches `[a-z][a-z0-9-]{0,31}`, such as `fix-facet-count`. It becomes the herdr workspace label, the herdr agent name and the fork's session name. With no task, use `fork`.
2. Run the script, passing the task verbatim on stdin (an empty heredoc when there is no task):

   ```bash
   ${CLAUDE_SKILL_DIR}/gork.sh <name> ${CLAUDE_SESSION_ID} <<'GORK_TASK'
   <task>
   GORK_TASK
   ```

   The script waits up to a minute for Claude to start in the new workspace.
3. Tell the user the workspace label. Do not work on the fork's task in this session.

If the script fails, report its error. It leaves the workspace open so that the user can see what happened there: do not close the workspace or retry without asking.
