FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG DOCKER_BUILDX_VERSION=0.27.0
ARG DOCKER_COMPOSE_VERSION=2.39.2
ARG DOCKER_COMPOSE_SWITCH_VERSION=1.0.5
ARG DOTNET_VERSION=9.0
ARG GIT_DELTA_VERSION=0.18.2
ARG GITUI_VERSION=0.27.0
ARG HELM_VERSION=3.18.6
ARG K8S_VERSION=1.33.2
ARG K9S_VERSION=0.50.9
ARG KUSTOMIZE_VERSION=5.7.1
ARG LAZYDOCKER_VERSION=0.24.1
ARG POWERSHELL_VERSION=7.5.2
ARG TERRAFORM_VERSION=1.13.0
ARG TZ=Africa/Johannesburg
ARG USERNAME=vscode

ENV container=docker
ENV DEBIAN_FRONTEND=noninteractive
ENV DEVCONTAINER=true
ENV DOCKER_BUILDKIT=1
ENV DOTNET_ROOT=/usr/local/dotnet
ENV EDITOR=nano
ENV NODE_VERSION=node
ENV NVM_DIR="/home/${USERNAME}/.nvm"
ENV NVM_SYMLINK_CURRENT=true
ENV PATH="${PATH}:${DOTNET_ROOT}"
ENV SHELL=/bin/zsh
ENV TZ="$TZ"
ENV VISUAL=nano

# Install APT Packages

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
  aggregate \
  dnsutils \
  fzf \
  gh \
  git-lfs \
  hey \
  ipset \
  iptables \
  libbz2-dev \
  libffi-dev \
  libgdbm-dev \
  liblzma-dev \
  libncurses5-dev \
  libreadline-dev \
  libsqlite3-dev \
  libxml2-dev \
  libxmlsec1-dev \
  pigz \
  pipx \
  python-is-python3 \
  python3-dev \
  python3-doc \
  python3-pip \
  python3-tk \
  python3-venv \
  software-properties-common \
  tk-dev \
  uuid-dev \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  && apt-get autoremove -y \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/*

# Install PowerShell

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="x64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/PowerShell/PowerShell/releases/download/v${POWERSHELL_VERSION}/powershell-${POWERSHELL_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" && \
  mkdir -p /opt/microsoft/powershell/7 && \
  tar zxf "powershell-${POWERSHELL_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" -C /opt/microsoft/powershell/7 && \
  chmod +x /opt/microsoft/powershell/7/pwsh && \
  ln -s /opt/microsoft/powershell/7/pwsh /usr/bin/pwsh && \
  rm "powershell-${POWERSHELL_VERSION}-linux-${ARCH_SUFFIX}.tar.gz"

# Install .NET

RUN curl -L https://dot.net/v1/dotnet-install.sh -o dotnet-install.sh && \
  chmod +x ./dotnet-install.sh && \
  ./dotnet-install.sh --channel $DOTNET_VERSION --install-dir /usr/local/dotnet && \
  ./dotnet-install.sh --channel $DOTNET_VERSION --runtime dotnet --install-dir /usr/local/dotnet && \
  rm dotnet-install.sh && \
  ln -s /usr/local/dotnet/dotnet /usr/local/bin/dotnet && \
  dotnet workload install aspire

# Install Python Tools

RUN pipx install --force --system-site-packages --pip-args '--no-cache-dir --force-reinstall' \
  autopep8 \
  bandit \
  black \
  flake8 \
  mypy \
  pipenv \
  pycodestyle \
  pydocstyle \
  pytest \
  virtualenv \
  yapf

# Install kubectl

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="amd64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  curl -LO "https://dl.k8s.io/release/v${K8S_VERSION}/bin/linux/${ARCH_SUFFIX}/kubectl" && \
  chmod +x kubectl && \
  mv kubectl /usr/local/bin/

# Install Kustomize

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="amd64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/kubernetes-sigs/kustomize/releases/download/kustomize%2Fv${KUSTOMIZE_VERSION}/kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCH_SUFFIX}.tar.gz" && \
  tar -zxvf "kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCH_SUFFIX}.tar.gz" && \
  mv kustomize /usr/local/bin/ && \
  rm "kustomize_v${KUSTOMIZE_VERSION}_linux_${ARCH_SUFFIX}.tar.gz"

# Install k9s

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="amd64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/derailed/k9s/releases/download/v${K9S_VERSION}/k9s_Linux_${ARCH_SUFFIX}.tar.gz" && \
  tar -zxvf "k9s_Linux_${ARCH_SUFFIX}.tar.gz" && \
  mv k9s /usr/local/bin/ && \
  rm k9s_Linux_${ARCH_SUFFIX}.tar.gz LICENSE README.md

# Install Helm

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="amd64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://get.helm.sh/helm-v${HELM_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" && \
  tar -zxvf "helm-v${HELM_VERSION}-linux-${ARCH_SUFFIX}.tar.gz" && \
  mv "linux-${ARCH_SUFFIX}/helm" /usr/local/bin/helm && \
  rm -rf "linux-${ARCH_SUFFIX}" "helm-v${HELM_VERSION}-linux-${ARCH_SUFFIX}.tar.gz"

# Install Terraform

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="amd64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://releases.hashicorp.com/terraform/${TERRAFORM_VERSION}/terraform_${TERRAFORM_VERSION}_linux_${ARCH_SUFFIX}.zip" && \
  unzip "terraform_${TERRAFORM_VERSION}_linux_${ARCH_SUFFIX}.zip" && \
  mv terraform /usr/local/bin/ && \
  rm "terraform_${TERRAFORM_VERSION}_linux_${ARCH_SUFFIX}.zip"

# Install AWS CLI

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="x86_64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="aarch64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  curl "https://awscli.amazonaws.com/awscli-exe-linux-${ARCH_SUFFIX}.zip" -o "awscliv2.zip" && \
  unzip awscliv2.zip && \
  ./aws/install && \
  rm -rf aws awscliv2.zip

# Install Azure CLI

RUN curl -sL https://aka.ms/InstallAzureCLIDeb | bash

# Install Lazydocker

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="x86_64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="arm64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/jesseduffield/lazydocker/releases/download/v${LAZYDOCKER_VERSION}/lazydocker_${LAZYDOCKER_VERSION}_Linux_${ARCH_SUFFIX}.tar.gz" && \
  tar -zxvf "lazydocker_${LAZYDOCKER_VERSION}_Linux_${ARCH_SUFFIX}.tar.gz" && \
  mv lazydocker /usr/local/bin/ && \
  rm "lazydocker_${LAZYDOCKER_VERSION}_Linux_${ARCH_SUFFIX}.tar.gz"

# Install gitui

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="x86_64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="aarch64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/extrawurst/gitui/releases/download/v${GITUI_VERSION}/gitui-linux-${ARCH_SUFFIX}.tar.gz" && \
  tar -zxvf "gitui-linux-${ARCH_SUFFIX}.tar.gz" && \
  mv gitui /usr/local/bin/ && \
  rm "gitui-linux-${ARCH_SUFFIX}.tar.gz"

# Install git-delta

RUN ARCH=$(dpkg --print-architecture) && \
  wget "https://github.com/dandavison/delta/releases/download/${GIT_DELTA_VERSION}/git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  sudo dpkg -i "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb" && \
  rm "git-delta_${GIT_DELTA_VERSION}_${ARCH}.deb"

# Install starship

RUN ARCH=$(dpkg --print-architecture) && \
  if [ "$ARCH" = "amd64" ]; then \
  ARCH_SUFFIX="x86_64"; \
  elif [ "$ARCH" = "arm64" ]; then \
  ARCH_SUFFIX="aarch64"; \
  else \
  echo "Unsupported architecture: $ARCH" && exit 1; \
  fi && \
  wget "https://github.com/starship/starship/releases/latest/download/starship-${ARCH_SUFFIX}-unknown-linux-musl.tar.gz" && \
  tar -zxvf "starship-${ARCH_SUFFIX}-unknown-linux-musl.tar.gz" && \
  mv starship /usr/local/bin/ && \
  rm "starship-${ARCH_SUFFIX}-unknown-linux-musl.tar.gz"

# Install Docker and Docker Compose


RUN . /etc/os-release && \
  ARCH="$(dpkg --print-architecture)" && \
  update-alternatives --set iptables /usr/sbin/iptables-legacy && \
  update-alternatives --set ip6tables /usr/sbin/ip6tables-legacy && \
  # \
  curl -sSL "https://packages.microsoft.com/keys/microsoft.asc" | gpg --dearmor > /usr/share/keyrings/microsoft-archive-keyring.gpg && \
  echo "deb [arch=${ARCH} signed-by=/usr/share/keyrings/microsoft-archive-keyring.gpg] https://packages.microsoft.com/repos/microsoft-${ID}-${VERSION_CODENAME}-prod ${VERSION_CODENAME} main" > /etc/apt/sources.list.d/microsoft.list && \
  # \
  apt-get update && apt-get install -y --no-install-recommends \
  moby-buildx \
  moby-cli \
  moby-compose \
  moby-engine \
  && apt-get clean && \
  rm -rf /var/lib/apt/lists/* && \
  case "${ARCH}" in amd64) COMPOSE_ARCH=x86_64 ;; arm64) COMPOSE_ARCH=aarch64 ;; *) esac && \
  DOCKER_COMPOSE_PATH="/usr/local/bin/docker-compose" && \
  DOCKER_CLI_PLUGINS_DIR="/usr/libexec/docker/cli-plugins" && \
  mkdir -p "${DOCKER_CLI_PLUGINS_DIR}" && \
  curl -fsSL "https://github.com/docker/compose/releases/download/v${DOCKER_COMPOSE_VERSION}/docker-compose-linux-${COMPOSE_ARCH}" -o "${DOCKER_COMPOSE_PATH}" && \
  chmod +x "${DOCKER_COMPOSE_PATH}" && \
  cp "${DOCKER_COMPOSE_PATH}" "${DOCKER_CLI_PLUGINS_DIR}" && \
  DOCKER_COMPOSE_SWITCH_PATH="/usr/local/bin/compose-switch" && \
  curl -fsSL "https://github.com/docker/compose-switch/releases/download/v${DOCKER_COMPOSE_SWITCH_VERSION}/docker-compose-linux-${ARCH}" -o "${DOCKER_COMPOSE_SWITCH_PATH}" && \
  chmod +x "${DOCKER_COMPOSE_SWITCH_PATH}" && \
  NEW_DOCKER_COMPOSE_PATH="/usr/local/bin/docker-compose-v1" && \
  mv "${DOCKER_COMPOSE_PATH}" "${NEW_DOCKER_COMPOSE_PATH}" && \
  update-alternatives --install ${DOCKER_COMPOSE_PATH} docker-compose /usr/local/bin/compose-switch 99 && \
  update-alternatives --install ${DOCKER_COMPOSE_PATH} docker-compose "${NEW_DOCKER_COMPOSE_PATH}" 1 && \
  DOCKER_BUILDX_PATH="/usr/local/bin/docker-buildx" && \
  curl -fsSL "https://github.com/docker/buildx/releases/download/v${DOCKER_BUILDX_VERSION}/buildx-v${DOCKER_BUILDX_VERSION}.linux-${ARCH}" -o "${DOCKER_BUILDX_PATH}" && \
  chmod +x "${DOCKER_BUILDX_PATH}" && \
  mv "${DOCKER_BUILDX_PATH}" "${DOCKER_CLI_PLUGINS_DIR}" && \
  chown -R ${USERNAME}:${USERNAME} /usr/libexec/docker/ && \
  usermod -aG docker ${USERNAME}

USER ${USERNAME}

# Install Node

RUN curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash

USER root

RUN \. /home/${USERNAME}/.nvm/nvm.sh && \
  nvm alias default node && \
  npm install -g npm@latest && \
  npm install -g pnpm@latest

USER ${USERNAME}

# Install Claude Code

RUN \. /home/${USERNAME}/.nvm/nvm.sh && \
  npm install -g @anthropic-ai/claude-code@latest

# Setup Directories, Configuration and Ownership

COPY dotfiles/ /home/${USERNAME}/
COPY scripts/post-create.sh /usr/local/bin/
COPY scripts/docker-init.sh /usr/local/share/

RUN sudo chmod +x /usr/local/bin/post-create.sh /usr/local/share/docker-init.sh

RUN sudo chown -R ${USERNAME}:${USERNAME} /usr/local/share/docker-init.sh

RUN sudo chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/

RUN sudo mkdir -p /home/${USERNAME}/.history /workspace && \
  sudo chown -R ${USERNAME}:${USERNAME} /workspace/

WORKDIR /workspace
