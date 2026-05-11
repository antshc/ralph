# ralph

Runs automated PR review via `afk.fix_prs:main` (from [brain-tools](https://github.com/antshc/brain)) inside the [cage](https://hub.docker.com/r/antshc/cage) container.

## Requirements

- Docker + Docker Compose
- A GitHub token with repo + PR read/write access

## Usage

```bash
alias ralph='COPILOT_GITHUB_TOKEN="$COPILOT_GITHUB_TOKEN" WORKSPACE="$(pwd)" docker compose -f ~/.ralph-zvm/docker-compose.yml run --rm --service-ports sandbox'

export REPO_DIR=/absolute/path/to/target/repo   # local git repo to review PRs in
export GITHUB_USER=your-github-username
export GITHUB_REPO=owner/repo                   # e.g. acme/myapp

docker compose up --build
```

On subsequent runs (image already built):

```bash
docker compose up
```

## Optional overrides

| Variable | Default | Description |
|---|---|---|
| `REPO_DIR` | — | **Required.** Absolute host path to the git repo |
| `GITHUB_USER` | — | **Required.** GitHub username for the review agent |
| `GITHUB_REPO` | — | **Required.** `owner/repo` to review PRs in |
| `GH_TOKEN` | — | GitHub token; passed to `gh` CLI for auth |

Pass extra `ralph` flags by overriding the compose `command`:

```bash
WORKSPACE=/home/pet/_projects/brain GITHUB_USER=antshc GITHUB_REPO=antshc/brain docker compose build --no-cache
WORKSPACE=/home/pet/_projects/brain GITHUB_USER=antshc GITHUB_REPO=antshc/brain docker compose -f docker-compose.yml -f docker-compose.bash.yml run ralph --remove-orphans

export AFK_DRY_RUN=0 && export AFK_DEBUG=1
afk_fix_prs /home/ubuntu/workspace antshc antshc/brain 10 --log-dir /var/log/ralph



```
