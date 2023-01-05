# FROM debian:11.6-slim
FROM docker:20.10-dind-rootless

# RUN apt update -y && \
  # apt install -y openssh-server && \
# RUN useradd -m dev

# USER rootless
ENV USER rootless

# ENTRYPOINT bash -c '. /srv/app/scripts/setup.sh && tail -f /dev/null'
ENTRYPOINT tail -f /dev/null
