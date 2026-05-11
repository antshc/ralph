FROM antshc/cage

# Install brain-tools from GitHub source
RUN python3 -m pip install --break-system-packages \
        git+https://github.com/antshc/brain.git

# Override default cage CMD; args are supplied by docker-compose command
# The cage ENTRYPOINT (/etc/mitmproxy/entrypoint.sh) applies iptables rules
# then drops to the ubuntu user via gosu before executing this CMD.
CMD ["afk_fix_prs"]
