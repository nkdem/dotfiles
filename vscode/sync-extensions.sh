#!/bin/bash
# Sync VS Code Insiders extensions to dotfiles

EXTENSIONS_FILE="$HOME/.config/vscode/extensions.txt"

# Export current extensions
code-insiders --list-extensions > "$EXTENSIONS_FILE"

echo "✓ Extensions synced to $EXTENSIONS_FILE"
