# ralph

Runs automated PR review via `afk.fix_prs:main` (from [brain-tools](https://github.com/antshc/brain)) inside the [cage](https://hub.docker.com/r/antshc/cage) container.

## Requirements

- Docker + Docker Compose
- A GitHub token with repo + PR read/write access

## Installation

Download and extract the latest runtime files:

```bash
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/install.sh | bash
```

This installs: `Dockerfile`, `docker-compose.yml`, `cron.sh`, `setup.sh`, and `rules/`.

## Usage

```bash
alias ralph='COPILOT_GITHUB_TOKEN="$COPILOT_GITHUB_TOKEN" WORKSPACE="$(pwd)" docker compose -f ~/"$INSTALL_DIR"/docker-compose.yml run --rm --service-ports sandbox'

export REPO_DIR=/absolute/path/to/target/repo   # local git repo to review PRs in
export GITHUB_USER=your-github-username
export GITHUB_REPO=owner/repo                   # e.g. acme/myapp

docker compose up --build
```

On subsequent runs (image already built):

```bash
docker compose up
```

## Auto-start on WSL


If systemd is enabled in WSL, you can register Ralph as a service so it starts automatically when WSL starts:

```bash
# Specify the path to your docker-compose.yml (recommended):
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/enable-wsl-autostart.sh | bash /path/to/docker-compose.yml

# Or, run without an argument to be prompted (defaults to ~/.ralph/docker-compose.yml):
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/enable-wsl-autostart.sh | bash
```
