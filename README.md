# ralph

Runs two automated agents in parallel (from [brain-tools](https://github.com/antshc/brain)) inside the [cage](https://hub.docker.com/r/antshc/cage) container:

- **`afk_fix_prs`** — reviews and fixes open pull requests
- **`afk_dev`** — picks the next open issue and implements it

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

### Disabling agents (for debugging)

Set either env var to `1` to disable the corresponding agent loop:

| Variable | Default | Effect |
|---|---|---|
| `AFK_DISABLE_FIX_PRS` | unset | Set to `1` to skip the `afk_fix_prs` loop |
| `AFK_DISABLE_DEV` | unset | Set to `1` to skip the `afk_dev` loop |

### Sleep intervals

| Variable | Default | Description |
|---|---|---|
| `AFK_FIX_PR_SLEEP` | `10` | Seconds between `afk_fix_prs` runs |
| `AFK_DEV_SLEEP` | `10` | Seconds between `afk_dev` runs |

## Auto-start on WSL

If systemd is enabled in WSL, you can register Ralph as a service so it starts automatically when WSL starts:

```bash
# Specify the path to your docker-compose.yml (recommended):
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/enable-wsl-autostart.sh | bash -s /path/to/docker-compose.yml

# Or, run without an argument to be prompted (defaults to ~/.ralph/docker-compose.yml):
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/enable-wsl-autostart.sh | bash
```

To disable and remove a service:

```bash
curl -fsSL https://raw.githubusercontent.com/antshc/ralph/main/disable-wsl-autostart.sh | bash
```

This lists all registered ralph services with their status and prompts you to enter the one to remove.
