---
name: bye
description: Check that nothing is left to do or clean up before the user closes this Claude Code session. Use only when the user types /bye or says they are about to close the session.
---

The user is about to close this session. Check that its work is finished and that nothing it started is left behind. Only look at what this session created or touched: leave other sessions' work alone.

Check the real state with tools, not from memory of the conversation:

1. **Follow-ups**: anything you said you would do later, or that the user asked for and isn't done.
2. **Changes** not committed or not pushed, in the repositories and worktrees this session touched.
3. **PRs and Jira tickets** this session opened or worked on: state, CI checks, unanswered review comments.
4. **Worktrees and local branches** this session created: remove the ones whose work is merged or abandoned, and say why the others stay.
5. **Running things** this session started: background commands, monitors, scheduled wakeups or cron jobs, subagents, servers, containers.
6. **Files** this session wrote outside its scratchpad directory and that aren't part of the work, such as downloads or temporary files.
7. **Main checkouts** this session changed, or left behind their remote after a merge.
8. **Memory**: what this session learned that future sessions need and that isn't saved yet. Save it now.

Ask before any cleanup that the user's instructions don't already allow, such as deleting a remote branch, closing a PR, or stopping something the user may still use.

Then reply in a few lines: what you cleaned up, what is still open and why, and what the user has to decide. If nothing is left, say so in one line.
