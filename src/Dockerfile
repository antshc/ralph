FROM antshc/workspace:latest

# Add the brain plugin marketplace at build time.
RUN copilot plugin marketplace add antshc/brain

ARG CACHEBUST
RUN pipx install git+https://github.com/antshc/brain.git

RUN mkdir -p /etc/sandbox
COPY cron.sh /etc/sandbox/cron.sh

CMD bash -c 'bash /etc/sandbox/cron.sh & sleep infinity'
