#!/usr/bin/env bash

set -euo pipefail

export DEBIAN_FRONTEND=noninteractive

echo "Installing utilities"
apt-get update -qq
apt-get install -qq -y \
  curl \
  fzf \
  git \
  make \
  ranger \
  tmux \
  tree \
  vim \
  wget

echo "Installing pentest and archive tools..."
apt-get install -qq -y \
  nmap \
  p7zip-full \
  unrar \
  unzip \
  zstd

echo "Installing Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -qq -y nodejs

install -d -o vagrant -g vagrant /home/vagrant/.vim/{undo,backup,swap}

echo "Installing OpenCode..."
sudo -u vagrant -H bash -c 'curl -fsSL https://opencode.ai/install | bash -s -- --no-modify-path'

echo "Installation complete."
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"
