FROM debian:stretch
ENV DEBIAN_FRONTEND noninteractive
ENV LC_ALL en_US.UTF-8
ENV LANGUAGE en_US:en
# Base
RUN \
    apt-get update && \
    apt-get install -y --no-install-recommends locales apt-utils wget gnupg curl apt-transport-https lsb-release ca-certificates && \
    echo "en_US.UTF-8 UTF-8" >> /etc/locale.gen && \
    locale-gen en_US.UTF-8 && \
    /usr/sbin/update-locale LANG=en_US.UTF-8 && \
    update-ca-certificates && \
    apt-get autoclean && apt-get clean && apt-get autoremove
RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list.d/bullseye.list && \
    apt -y update && apt install -y -qq skopeo jq
RUN curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
RUN curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256"
RUN install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client && \
    wget https://github.com/digitalocean/doctl/releases/download/v1.65.0/doctl-1.65.0-linux-amd64.tar.gz && \
    tar xf doctl-1.65.0-linux-amd64.tar.gz && \
    mv doctl /usr/local/bin
RUN curl -s -L "https://github.com/loft-sh/devspace/releases/tag/v5.16.0" | sed -nE 's!.*"([^"]*devspace-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o devspace && chmod +x devspace && \
    install devspace /usr/local/bin;