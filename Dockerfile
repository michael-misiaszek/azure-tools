from ubuntu:22.04

RUN apt-get update && apt-get install -y curl coreutils
RUN curl https://packages.microsoft.com/keys/microsoft.asc | tee /etc/apt/trusted.gpg.d/microsoft.asc && curl https://packages.microsoft.com/config/ubuntu/22.04/prod.list | tee /etc/apt/sources.list.d/mssql-release.list
RUN apt-get update && ACCEPT_EULA=Y apt-get install -y \
    net-tools \
    dnsutils \
    iputils-ping \
    jq \
    nmap \
    openssl \
    openssh-client \
    python3 \
    nodejs \
    vim \
    git \
    wget \
    bzip2 \
    unzip \
    less \
    gpg \
    make \
    g++ \
    mssql-tools18 \
    unixodbc-dev \
    redis
RUN apt-get clean && rm -rf /var/lib/apt/lists/*

WORKDIR /root

# Install Homebrew
RUN /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
ENV PATH="$PATH:/home/linuxbrew/.linuxbrew/bin:/opt/mssql-tools18/bin"
# # Install rancher v2.9.0
RUN wget https://github.com/rancher/cli/releases/download/v2.9.0/rancher-linux-amd64-v2.9.0.tar.gz
RUN tar xzf rancher-linux-amd64-v2.9.0.tar.gz && cp rancher-v2.9.0/rancher /usr/bin
COPY 80-rancher /etc/update-motd.d/80-rancher
RUN chmod 755 /etc/update-motd.d/80-rancher

# Install Terraform Istioctl Kubectl Helm & K9s
RUN brew tap hashicorp/tap && brew install hashicorp/tap/terraform && brew update && brew install istioctl && brew install helm && brew install derailed/k9s/k9s && brew install kubernetes-cli && brew upgrade hashicorp/tap/terraform
# RUN brew upgrade hashicorp/tap/terraform

# Install Azure CLI
RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

ENV HOSTNAME michael-shell
USER root
ENTRYPOINT ["tail"]
CMD ["-f", "/dev/null"]
