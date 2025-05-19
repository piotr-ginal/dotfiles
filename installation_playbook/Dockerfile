FROM debian:bookworm-slim

RUN apt update && apt install sudo pipx -y && apt-get clean

RUN useradd -ms /bin/bash linuxuser

RUN echo "linuxuser ALL=(ALL) NOPASSWD:ALL" > /etc/sudoers.d/linuxuser && \
    chmod 0440 /etc/sudoers.d/linuxuser

USER linuxuser

RUN pipx install --include-deps ansible

ENV PATH="/home/linuxuser/.local/bin:${PATH}"
