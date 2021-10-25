FROM debian:stretch

RUN apt-get update && \
    apt-get install -y --no-install-recommends wget curl apt-transport-https lsb-release ca-certificates

RUN echo 'deb http://deb.debian.org/debian bullseye main' > /etc/apt/sources.list.d/bullseye.list && \
    apt -y update && apt install -y -qq skopeo jq && \
    curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl" && \
    curl -LO "https://dl.k8s.io/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl.sha256" && \
    echo "$(<kubectl.sha256) kubectl" | sha256sum --check && \
    install -o root -g root -m 0755 kubectl /usr/local/bin/kubectl && \
    kubectl version --client && \
    wget https://github.com/digitalocean/doctl/releases/download/v1.65.0/doctl-1.65.0-linux-amd64.tar.gz && \
    tar xf doctl-1.65.0-linux-amd64.tar.gz && \
    mv doctl /usr/local/bin
RUN curl -s -L "https://github.com/loft-sh/devspace/releases/latest" | sed -nE 's!.*"([^"]*devspace-linux-amd64)".*!https://github.com\1!p' | xargs -n 1 curl -L -o devspace && chmod +x devspace && \
    install devspace /usr/local/bin;
RUN ls