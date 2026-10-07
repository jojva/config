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

## Secrets

- Never read, print or search files that hold secrets: `.env` files, `~/.secretsrc`,
  private SSH keys, `~/.aws/credentials`, tokens and auth files of other tools.
- Never print environment variables (`env`, `printenv`, `echo $SOME_TOKEN`...).
- If a task needs a secret, ask me to provide it in a way that doesn't expose it
  (e.g. `op run`), or ask me to run the command myself.
- Never write a secret into a file, a commit, a log or a command's output.

## Settings of my apps

- Unless I asked for that change, ask me before you edit the configuration or settings
  of my personal apps (VSCode, terminal, shell, git config...), even when the change
  fixes the problem I asked about. Tell me which file and setting you would change,
  and to what value.
