FROM mcr.microsoft.com/devcontainers/base:ubuntu

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

ENV DEBIAN_FRONTEND=noninteractive
ENV DEVCONTAINER=true
ENV DOTNET_ROOT="/usr/local/dotnet"
ENV EDITOR=nano
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
  && apt-get clean && rm -rf /var/lib/apt/lists/*

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

# Setup Directories, Configuration and Ownership

RUN mkdir -p /home/${USERNAME}/.history /workspace  && \
  chown -R ${USERNAME}:${USERNAME} /workspace

COPY dotfiles/ /home/${USERNAME}/
COPY scripts/ /usr/local/bin/

RUN chown -R ${USERNAME}:${USERNAME} /home/${USERNAME}/

USER ${USERNAME}

WORKDIR /workspace
