# Handoff: Grafana + Elasticsearch Observability for ralph/logs

**Session type:** grill-me design interview (in progress)  
**Next session:** Continue grill-me — resolve remaining open decisions, then implement.  
**Suggested skill:** `/wf:grill-me`

---

## Context

The `ralph/` project runs an AFK autonomous coding agent inside Docker. It produces three log streams, volume-mounted to the host at `ralph/logs/`:

| Directory | Producer | Format |
|---|---|---|
| `ralph/logs/mitmproxy/` | mitmproxy proxy | Plaintext: `[HH:MM:SS.mmm] [ACTION] METHOD URL << STATUS` |
| `ralph/logs/copilot/` | Copilot CLI | **JSONL** (one JSON object per line, confirmed via `cage/src/copilot-alias.sh` `--output-format json --log-level debug`) |
| `ralph/logs/ralph/` | Python `afk` service | Two sub-formats: Python logging (`YYYY-MM-DD HH:MM:SS,mmm LEVEL logger.name message key=value`) and JSON execution logs (`execution-log-*.json`) |

The goal is to add a Grafana + Elasticsearch observability stack to ingest and visualize these logs.

---

## Decisions Made

| # | Decision | Choice |
|---|---|---|
| 1 | **Where does the stack live?** | `ralph/` project as a new `docker-compose.observability.yml` — collocated, reuses existing volume mounts |
| 2 | **Log shipper** | **Logstash** |
| 3 | **Logstash input method** | **File input directly** — Logstash container mounts `./logs/` volumes and reads files via `file { path => ... }` |
| 4 | **Elasticsearch version** | **Elasticsearch 7.17** — no TLS/security by default, simpler local config, Grafana ES datasource supports it well |
| 5 | **Index strategy** | **One index per log type**: `logs-mitmproxy-*`, `logs-copilot-*`, `logs-ralph-*` |
| 6 | **Parsing depth** | **Selective**: full Grok+kv for `ralph` logs, basic (timestamp/action/method/url/status) for `mitmproxy`, JSON decode for `copilot` JSONL |

---

## Open Decisions (continue grilling from here)

The grill-me session was interrupted after Q6. Continue from **Q7**:

7. **Retention / ILM policy** — How long to keep each index? (e.g. 7 days, 30 days, unlimited for this dev setup?)
8. **Grafana datasource config** — One datasource per index or a single wildcard `logs-*` datasource?
9. **Dashboard design** — What panels/visualizations are needed per log type? (e.g. request rate, ALLOWED vs BLOCKED counts for mitmproxy; log level breakdown + PR throughput for ralph; event type timeline for copilot)
10. **Authentication** — Any auth between Logstash → ES → Grafana, or all open/anonymous for local dev?
11. **Startup & file ordering** — Logstash `sincedb` persistence: should it replay all historical logs on each restart or only tail new lines?
12. **Implementation location** — Where does the Logstash pipeline config live? (e.g. `ralph/logstash/pipeline/`)

---

## Relevant Files

- `ralph/docker-compose.dev.yml` — current dev compose (shows volume mounts for all three log dirs)
- `ralph/runtime/docker-compose.yml` — production-style compose
- `cage/src/copilot-alias.sh` — confirms copilot output format is JSONL, log dir is `/var/log/copilot`
- `ralph/logs/ralph/fix_prs-2026-05-12.log` — sample ralph log (Python logging format)
- `ralph/logs/mitmproxy/mitmproxy_20260512.log` — sample mitmproxy log
- `ralph/logs/copilot/process-1778610617026-203.log` — sample copilot JSONL log

---

## Notes for Next Agent

- The copilot JSONL log mixes two event categories worth separating: **ephemeral** events (streaming deltas, `"ephemeral": true`) and **durable** events (tool calls, messages, session events). Consider filtering ephemerals out in Logstash.
- Ralph logs have a second format: `execution-log-YYYY-MM-DD.json` — currently `{}` (empty object), but may grow. Handle gracefully.
- The three log directories are already declared as named volumes in `docker-compose.dev.yml` — the observability compose file can reference the same host paths directly (bind mounts, not named volumes).
- Logstash 7.17 image: `docker.elastic.co/logstash/logstash:7.17.x`
- Elasticsearch 7.17 image: `docker.elastic.co/elasticsearch/elasticsearch:7.17.x`
- Grafana image: `grafana/grafana:latest` (has built-in Elasticsearch datasource plugin)
