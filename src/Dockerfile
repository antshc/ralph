FROM antshc/cage
# Install brain-tools from GitHub source (runs at build time, before proxy is up)
# Unset proxy vars inherited from cage image — mitmproxy is not running during docker build
# RUN HTTP_PROXY="" HTTPS_PROXY="" ALL_PROXY="" pipx install git+https://github.com/antshc/brain.git

COPY setup.sh /etc/sandbox/setup.sh
COPY cron.sh /etc/sandbox/cron.sh

# Override default cage CMD; cage ENTRYPOINT applies iptables, optionally runs cron.sh,
# then drops to the ubuntu user via gosu before executing this CMD.

CMD bash -c 'bash /etc/sandbox/cron.sh & sleep infinity'
