FROM mcr.microsoft.com/devcontainers/base:ubuntu

ARG GIT_DELTA_VERSION=0.18.2
ARG GITUI_VERSION=0.27.0
ARG K9S_VERSION=0.50.9
ARG KUSTOMIZE_VERSION=5.7.1
ARG LAZYDOCKER_VERSION=0.24.1
ARG TZ=Africa/Johannesburg
ARG USERNAME=vscode

ENV DEVCONTAINER=true
ENV EDITOR=nano
ENV SHELL=/bin/zsh
ENV TZ="$TZ"
ENV VISUAL=nano

RUN mkdir -p /workspace && \
  chown -R ${USERNAME}:${USERNAME} /workspace

# Install APT Packages

RUN apt-get update && apt-get upgrade -y && apt-get install -y --no-install-recommends \
  aggregate \
  fzf \
  hey \
  ipset \
  software-properties-common \
  vim \
  zsh-autosuggestions \
  zsh-syntax-highlighting \
  && apt-get clean && rm -rf /var/lib/apt/lists/*

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

USER ${USERNAME}

RUN mkdir -p /home/${USERNAME}/.config

COPY dotfiles/.zshrc /home/${USERNAME}/
COPY dotfiles/.config/starship.toml /home/${USERNAME}/.config/

COPY post-create.sh /usr/local/bin/

WORKDIR /workspace
