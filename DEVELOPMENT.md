# ralph

Runs automated PR review via `afk.fix_prs:main` (from [brain-tools](https://github.com/antshc/brain)) inside the [cage](https://hub.docker.com/r/antshc/cage) container.

## Requirements

- Docker + Docker Compose
- A GitHub token with repo + PR read/write access

## Optional overrides

| Variable | Default | Description |
|---|---|---|
| `REPO_DIR` | — | **Required.** Absolute host path to the git repo |
| `GITHUB_USER` | — | **Required.** GitHub username for the review agent |
| `GITHUB_REPO` | — | **Required.** `owner/repo` to review PRs in |
| `GH_TOKEN` | — | GitHub token; passed to `gh` CLI for auth |

Pass extra `ralph` flags by overriding the compose `command`:

```bash
WORKSPACE=/home/pet/_projects/brain WORKTREES=/home/pet/_projects/brain.worktrees GITHUB_USER=antshc GITHUB_REPO=antshc/brain docker compose build --no-cache
WORKSPACE=/home/pet/_projects/brain WORKTREES=/home/pet/_projects/brain.worktrees GITHUB_USER=antshc GITHUB_REPO=antshc/brain docker compose -f docker-compose.yml -f docker-compose.bash.yml run ralph

WORKSPACE=/home/pet/_projects/brain WORKTREES=/home/pet/_projects/brain.worktrees GITHUB_USER=antshc GITHUB_REPO=antshc/brain docker compose -f docker-compose.yml run ralph

export AFK_DRY_RUN=0 && export AFK_DEBUG=1
afk_fix_prs --repo_dir /home/ubuntu/workspace --github_user antshc --github_repo antshc/brain

```
