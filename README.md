# ralph

Runs automated PR review via `afk.fix_prs:main` (from [brain-tools](https://github.com/antshc/brain)) inside the [cage](https://hub.docker.com/r/antshc/cage) container.

## Requirements

- Docker + Docker Compose
- A GitHub token with repo + PR read/write access

## Installation

Download and extract the latest runtime files:

```bash
read -p "Installation directory [.ralph]: " INSTALL_DIR; INSTALL_DIR="${INSTALL_DIR:-.ralph}"
mkdir -p ~/$INSTALL_DIR
curl -L https://github.com/antshc/ralph/releases/latest/download/ralph.tar.gz | tar -xz -C ~/$INSTALL_DIR
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
