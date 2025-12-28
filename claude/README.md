# Claude Configuration

Custom Claude Code configuration with enhanced statusline.

## Files

- `statusline-command.sh` - Main statusline script with session and weekly usage
- `fetch-claude-usage.swift` - Fetches usage data from Claude API
- `statusline-config.txt` - Toggle features (directory, branch, usage, progress bar, weekly)
- `settings.json` - Claude Code settings
- `commands/` - Custom commands directory
- `setup.sh` - Setup script to create symlinks

## Setup

Run the setup script to create symlinks in `~/.claude/`:

```bash
~/.config/claude/setup.sh
```

This will:
1. Back up any existing files to `backup-YYYYMMDD-HHMMSS/`
2. Create symlinks from `~/.claude/` to `~/.config/claude/`

## Statusline Features

The custom statusline shows:
- Current directory name
- Git branch (if in a git repo)
- Session usage (5-hour limit) with progress bar
- Weekly usage (7-day limit) with progress bar
- Reset times

Format: `dir │ ⎇ branch │ 5h:12% ▓░░░░░░░░░ → 05:00 AM ╱ 7d:44% ▓▓▓▓░░░░░░ → Thursday`

### Configuration

Edit `statusline-config.txt` to toggle features:

```bash
SHOW_DIRECTORY=1
SHOW_BRANCH=1
SHOW_USAGE=1
SHOW_PROGRESS_BAR=1
SHOW_WEEKLY=1
```

Set to `0` to disable any feature.

## Requirements

- Swift (for fetching usage data)
- Claude session key in `~/.claude-session-key` (keep this local, don't commit!)
