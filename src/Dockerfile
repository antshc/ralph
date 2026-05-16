FROM antshc/cage

# Install brain-tools from GitHub source at build time.
# cage runtime proxy variables are configured in entrypoint.sh,
# so docker build uses direct internet access.
RUN pipx install git+https://github.com/antshc/brain.git

# Override default cage CMD; cage ENTRYPOINT applies iptables, optionally runs cron.sh,
# then drops to the ubuntu user via gosu before executing this CMD.

CMD bash -c 'bash /etc/sandbox/cron.sh & sleep infinity'
