FROM antshc/cage

# # Install brain-tools from GitHub source at build time.
# # cage runtime proxy variables are configured in entrypoint.sh,
# # so docker build uses direct internet access.

USER ubuntu
RUN pipx install git+https://github.com/antshc/brain.git

# # Install the ralph Copilot plugin at build time.
RUN copilot plugin marketplace add antshc/brain \
     && copilot plugin install ralph@brain
USER root

# Override default cage CMD; cage ENTRYPOINT applies iptables, optionally runs cron.sh,
# then drops to the ubuntu user via gosu before executing this CMD.

COPY cron.sh /etc/sandbox/cron.sh

CMD bash -c 'bash /etc/sandbox/cron.sh & sleep infinity'
