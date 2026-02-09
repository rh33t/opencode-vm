#!/usr/bin/env bash

set -euo pipefail

echo "Installing development utilities..."
export DEBIAN_FRONTEND=noninteractive
apt-get update -qq
apt-get install -qq -y tree fzf ranger git curl wget vim tmux

echo "Installing Node.js LTS..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | bash -
apt-get install -qq -y nodejs

echo "Installation complete!"
echo "Node.js version: $(node --version)"
echo "npm version: $(npm --version)"

# create vim directories for undo, backup, and swap files
mkdir -p ~/.vim/{undo,backup,swap}
