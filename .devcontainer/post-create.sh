#!/bin/bash

set -euo pipefail

echo "Updating NPM..."
npm install -g npm@latest

echo "Installing Claude Code..."
npm install -g @anthropic-ai/claude-code@latest

echo "Installing .NET Aspire..."
sudo dotnet workload install aspire

echo "Post-creation setup complete!"
