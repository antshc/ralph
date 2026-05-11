FROM antshc/cage

# Install brain-tools from GitHub source (runs at build time, before proxy is up)
# Unset proxy vars inherited from cage image — mitmproxy is not running during docker build
RUN HTTP_PROXY="" HTTPS_PROXY="" ALL_PROXY="" \
    pipx install git+https://github.com/antshc/brain.git \
    && copilot plugin marketplace add antshc/brain \
    && copilot plugin install ralph@brain

# Override default cage CMD; args are supplied by docker-compose command
# The cage ENTRYPOINT (/etc/mitmproxy/entrypoint.sh) applies iptables rules
# then drops to the ubuntu user via gosu before executing this CMD.
CMD ["afk_fix_prs"]
