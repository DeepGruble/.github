#!/bin/bash
# sync-mcp.sh - Sync MCP server configs to tool-specific locations
#
# Usage: ./sync-mcp.sh [project-path]
# If no project path provided, syncs to current directory
#
# This script merges:
# 1. Org-wide MCP servers from .github repo
# 2. Project-specific MCP servers from local .deepgruble/mcp/servers.json

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
ORG_CONFIG="$SCRIPT_DIR/servers.json"

# Determine target directory
if [ -n "$1" ]; then
    TARGET_DIR="$1"
else
    TARGET_DIR="$(pwd)"
fi

PROJECT_CONFIG="$TARGET_DIR/.deepgruble/mcp/servers.json"
OUTPUT_FILE="$TARGET_DIR/.mcp.json"

# Ensure org config exists
if [ ! -f "$ORG_CONFIG" ]; then
    echo "Error: Org config not found at $ORG_CONFIG"
    exit 1
fi

echo "Syncing MCP configs..."
echo "Org config: $ORG_CONFIG"
echo "Target: $TARGET_DIR"
echo ""

# Check if jq is available
if ! command -v jq &> /dev/null; then
    echo "Error: jq is required but not installed."
    echo "Install with: brew install jq"
    exit 1
fi

# Merge configs or use org config only
if [ -f "$PROJECT_CONFIG" ]; then
    echo "Found project config: $PROJECT_CONFIG"
    echo "Merging org + project configs..."
    jq -s '.[0].mcpServers * .[1].mcpServers | {mcpServers: .}' \
        "$ORG_CONFIG" "$PROJECT_CONFIG" > "$OUTPUT_FILE"
else
    echo "No project config found, using org config only"
    cp "$ORG_CONFIG" "$OUTPUT_FILE"
fi

# Also create .cursor/mcp.json
echo "Creating .cursor/mcp.json..."
mkdir -p "$TARGET_DIR/.cursor"
cp "$OUTPUT_FILE" "$TARGET_DIR/.cursor/mcp.json"

echo ""
echo "MCP servers configured:"
jq -r '.mcpServers | keys[]' "$OUTPUT_FILE" | while read server; do
    echo "  - $server"
done

echo ""
echo "Done! Restart your AI tool to load the MCP servers."
