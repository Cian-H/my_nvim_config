FROM ubuntu:24.04

# Prevent interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Install essential dependencies
RUN apt-get update && apt-get install -y --no-install-recommends \
    git \
    curl \
    ca-certificates \
    build-essential \
    unzip \
    tar \
    ripgrep \
    fd-find \
    python3 \
    python3-pip \
    python3-venv \
    nodejs \
    npm \
    && rm -rf /var/lib/apt/lists/*

# Install Neovim (stable/latest precompiled binary)
RUN curl -LO https://github.com/neovim/neovim/releases/download/stable/nvim-linux-x86_64.tar.gz \
    && tar -C /opt -xzf nvim-linux-x86_64.tar.gz \
    && rm nvim-linux-x86_64.tar.gz \
    && ln -s /opt/nvim-linux-x86_64/bin/nvim /usr/local/bin/nvim

# Create a non-root user and setup home directory
RUN useradd -m -s /bin/bash nvimuser
USER nvimuser
ENV HOME=/home/nvimuser
WORKDIR /workspace

# Copy the Neovim configuration files
RUN mkdir -p $HOME/.config/nvim
COPY --chown=nvimuser:nvimuser . $HOME/.config/nvim

# Pre-install plugins using Lazy.nvim sync
RUN nvim --headless "+Lazy! sync" +qa

# Run neovim headlessly for a short period to allow tree-sitter-manager and mason to install tools
RUN nvim --headless -c "sleep 15" -c "qa"

# Set up entrypoint
ENTRYPOINT ["nvim"]
