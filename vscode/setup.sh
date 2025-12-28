#!/bin/bash
# Setup script to symlink VS Code Insiders settings.json from dotfiles

set -e

VSCODE_CONFIG_DIR="$HOME/Library/Application Support/Code - Insiders/User"
DOTFILES_VSCODE_DIR="$HOME/.config/vscode"
BACKUP_DIR="$HOME/.config/vscode/backups"
SETTINGS_FILE="settings.json"

# Create backup directory if it doesn't exist
mkdir -p "$BACKUP_DIR"

# Check if settings.json exists in VS Code config
if [ -f "$VSCODE_CONFIG_DIR/$SETTINGS_FILE" ]; then
  TIMESTAMP=$(date +%Y%m%d_%H%M%S)
  BACKUP_FILE="$BACKUP_DIR/${SETTINGS_FILE}.backup_$TIMESTAMP"
  
  echo "⚠️  Found existing $SETTINGS_FILE, backing up to:"
  echo "   $BACKUP_FILE"
  
  cp "$VSCODE_CONFIG_DIR/$SETTINGS_FILE" "$BACKUP_FILE"
  rm "$VSCODE_CONFIG_DIR/$SETTINGS_FILE"
fi

# Create symlink
if [ -f "$DOTFILES_VSCODE_DIR/$SETTINGS_FILE" ]; then
  ln -s "$DOTFILES_VSCODE_DIR/$SETTINGS_FILE" "$VSCODE_CONFIG_DIR/$SETTINGS_FILE"
  echo "✓ Symlinked settings.json from dotfiles"
else
  echo "✗ settings.json not found in $DOTFILES_VSCODE_DIR"
  echo "  Creating an empty one..."
  mkdir -p "$DOTFILES_VSCODE_DIR"
  touch "$DOTFILES_VSCODE_DIR/$SETTINGS_FILE"
  ln -s "$DOTFILES_VSCODE_DIR/$SETTINGS_FILE" "$VSCODE_CONFIG_DIR/$SETTINGS_FILE"
fi

echo "✓ VS Code Insiders setup complete"
echo "  Config: $VSCODE_CONFIG_DIR/$SETTINGS_FILE -> $DOTFILES_VSCODE_DIR/$SETTINGS_FILE"
[ -d "$BACKUP_DIR" ] && [ "$(ls -A "$BACKUP_DIR")" ] && echo "  Backups: $BACKUP_DIR"
