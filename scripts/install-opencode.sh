#!/usr/bin/env bash
# Install OpenCode CLI

set -euo pipefail

echo "Installing OpenCode..."
curl -fsSL https://opencode.ai/install | bash
echo "OpenCode installation complete!"
