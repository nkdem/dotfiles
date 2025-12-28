#!/bin/bash
# Setup script for Claude dotfiles
# Backs up existing files and creates symlinks

CLAUDE_DIR="$HOME/.claude"
CONFIG_DIR="$HOME/.config/claude"
BACKUP_DIR="$HOME/.config/claude/backup-$(date +%Y%m%d-%H%M%S)"

# Files to symlink
FILES=(
  "statusline-command.sh"
  "fetch-claude-usage.swift"
  "statusline-config.txt"
  "settings.json"
)

# Directories to symlink
DIRS=(
  "commands"
)

echo "Setting up Claude dotfiles..."

# Create backup directory if any files exist
needs_backup=0
for file in "${FILES[@]}"; do
  if [ -f "$CLAUDE_DIR/$file" ] && [ ! -L "$CLAUDE_DIR/$file" ]; then
    needs_backup=1
    break
  fi
done

for dir in "${DIRS[@]}"; do
  if [ -d "$CLAUDE_DIR/$dir" ] && [ ! -L "$CLAUDE_DIR/$dir" ]; then
    needs_backup=1
    break
  fi
done

if [ $needs_backup -eq 1 ]; then
  echo "Creating backup directory: $BACKUP_DIR"
  mkdir -p "$BACKUP_DIR"
fi

# Backup and symlink files
for file in "${FILES[@]}"; do
  target="$CLAUDE_DIR/$file"
  source="$CONFIG_DIR/$file"

  if [ -L "$target" ]; then
    echo "✓ $file already symlinked"
  elif [ -f "$target" ]; then
    echo "📦 Backing up $file"
    mv "$target" "$BACKUP_DIR/"
    echo "🔗 Symlinking $file"
    ln -s "$source" "$target"
  elif [ -f "$source" ]; then
    echo "🔗 Symlinking $file"
    ln -s "$source" "$target"
  else
    echo "⚠️  $file not found in $CONFIG_DIR"
  fi
done

# Backup and symlink directories
for dir in "${DIRS[@]}"; do
  target="$CLAUDE_DIR/$dir"
  source="$CONFIG_DIR/$dir"

  if [ -L "$target" ]; then
    echo "✓ $dir already symlinked"
  elif [ -d "$target" ]; then
    echo "📦 Backing up $dir"
    mv "$target" "$BACKUP_DIR/"
    echo "🔗 Symlinking $dir"
    ln -s "$source" "$target"
  elif [ -d "$source" ]; then
    echo "🔗 Symlinking $dir"
    ln -s "$source" "$target"
  else
    echo "⚠️  $dir not found in $CONFIG_DIR"
  fi
done

echo ""
echo "✅ Setup complete!"
if [ $needs_backup -eq 1 ]; then
  echo "📦 Backup saved to: $BACKUP_DIR"
fi
