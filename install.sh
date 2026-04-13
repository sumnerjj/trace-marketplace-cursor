#!/usr/bin/env bash
set -euo pipefail

PLUGIN_DIR="${HOME}/.cursor/plugins/local/session-logger"

echo "Installing session-logger plugin for Cursor..."

# Clone or update the plugin
if [ -d "$PLUGIN_DIR" ]; then
  echo "Updating existing installation..."
  cd "$PLUGIN_DIR" && git pull
else
  echo "Cloning plugin..."
  mkdir -p "$(dirname "$PLUGIN_DIR")"
  git clone https://github.com/sumnerjj/trace-marketplace-cursor "$PLUGIN_DIR"
fi

echo ""
echo "Done! Reload Cursor (Developer: Reload Window) to load the plugin."
echo "Debug log: ~/.cursor/session-logger.log"
