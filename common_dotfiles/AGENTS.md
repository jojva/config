# Instructions for coding agents

User-wide rules, versioned in https://github.com/jojva/config and linked as both
`~/.codex/AGENTS.md` (Codex) and `~/.claude/CLAUDE.md` (Claude Code).

## Worktrees

- Unless I explicitly ask you to work in the main repository, do all work in a git
  worktree, in `~/tmp/worktrees/<repo>/<worktree>`.
- Exception: in my config repo (`~/workspace/config`, github.com/jojva/config), always
  work directly in the main repository.
- The worktree is named after the last part of its branch. Branches are named
  `joris/<type>/<name>`, where `<name>` starts with the SRCH ticket number or the PR
  number when there is one: branch `joris/feat/srch-4242-fix-that-bug` goes in
  worktree `srch-4242-fix-that-bug`. Without a ticket or PR, `<name>` is just a short
  description.
- The agent that creates a worktree is responsible for removing it
  (`git worktree remove`) once the work is done: merged, abandoned, or when I say so.
  Same thing for the local branch.
- Do not touch other session's work.

## Pull Requests

- Always open PRs as draft.
- Some repositories require the PR description to be written by a human. In these cases, keep the PR template of the repo, I'll fill the description later.

## Optimistic push

- When the task includes a push, you may push before the local build and tests have
  passed, if you are confident they will. CI then starts sooner: when you're right,
  that's CI time gained.

## Communication

Whenever you've created a PR, or a branch, or a worktree, or a combination of these, please tell me clearly. For example:
"I created PR <link>, based on branch <branch>, and worktree <worktree>".

## Writing as me

- Before you write text that other people will read under my name, read `joris.md` and
  follow it. It sits next to this file, as `~/.claude/joris.md` and `~/.codex/joris.md`.
  This covers PR titles and descriptions, review comments and replies, commit messages,
  Jira tickets and comments, and Slack messages. It does not cover your replies to me.
- Keep `joris.md` up to date. When you see me rewrite text you drafted, or read text I
  wrote myself, and it shows a habit that `joris.md` misses or contradicts, update it in
  the same session. Its last section says how.

## Secrets

- Never read, print or search files that hold secrets: `.env` files, `~/.secretsrc`,
  private SSH keys, `~/.aws/credentials`, tokens and auth files of other tools.
- Never print environment variables (`env`, `printenv`, `echo $SOME_TOKEN`...).
- Treat URLs that carry credentials as secrets: Slack/Teams/Discord incoming webhooks,
  and URLs with tokens in the query string or user info. When listing webhooks or
  integration settings, print only ids and hosts.
- If a task needs a secret, ask me to provide it in a way that doesn't expose it
  (e.g. `op run`), or ask me to run the command myself.
- Never write a secret into a file, a commit, a log or a command's output.

## Settings of my apps

- Unless I asked for that change, ask me before you edit the configuration or settings
  of my personal apps (VSCode, terminal, shell, git config...), even when the change
  fixes the problem I asked about. Tell me which file and setting you would change,
  and to what value.
