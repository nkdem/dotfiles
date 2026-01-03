After making a set of changes to files or satisfying a task, you MUST display a `terminal-notifier` notification to tell me what's been done. Use a title and a brief descriptive message. Here's an example:

```bash
terminal-notifier -message "I've finished refactoring the FooBar class into smaller methods" -title "Claude Code" -group $PWD -execute "/opt/homebrew/bin/wezterm cli activate-pane --pane-id $WEZTERM_PANE" -activate com.github.wez.wezterm
```

