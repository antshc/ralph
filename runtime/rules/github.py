from mitmproxy import http

ALLOWED_REPOS = [
    "/hpe-cds/zerto-zic",
    "/hpe-cds/zerto-zvm",
    "/hpe-cds/zerto-promotion-workers",
    "/anton-shcherbyna_hpeprod/zic-board",
    "/anton-shcherbyna_hpeprod/zvm-board",
    "/anton-shcherbyna_hpeprod/promotion-workers-board",
]

# api.github.com paths are prefixed with /repos/<org>/<repo>/...
_API_PREFIXES = ["/repos" + r for r in ALLOWED_REPOS]

_FILTERED_HOSTS = {"github.com", "api.github.com"}

ENVIRONMENT = {
    "hosts": {
        "github.com",
        "api.github.com",
        "objects.githubusercontent.com",
        "raw.githubusercontent.com",
        "release-assets.githubusercontent.com",
    },
}


def check_request(flow: http.HTTPFlow) -> None:
    host = flow.request.pretty_host.lower()
    if host not in _FILTERED_HOSTS:
        # objects/raw/release-assets hosts: no path restriction
        return
    path = flow.request.path
    prefixes = _API_PREFIXES if host == "api.github.com" else ALLOWED_REPOS
    if not any(path.startswith(p) for p in prefixes):
        body = (
            "[Sandbox Firewall] Access to '{}{}' is blocked.\n"
            "Only the following repositories are allowed:\n{}"
        ).format(host, path, "\n".join("  github.com" + r for r in ALLOWED_REPOS))
        flow.response = http.Response.make(
            403,
            body.encode(),
            {"Content-Type": "text/plain"},
        )
