local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config.enable_scroll_bar = true

config.color_scheme = "Tokyo Night"
config.window_background_opacity = 0.98

config.font_size = 20

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = true

config.leader = { key = "§", timeout_milliseconds = 1000 }

config.keys = {
	{
		key = "l",
		mods = "CTRL|SHIFT",
		action = wezterm.action.DisableDefaultAssignment,
	},
	{
		key = "LeftArrow",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Left"),
	},
	{
		key = "RightArrow",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Right"),
	},
	{
		key = "UpArrow",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Up"),
	},
	{
		key = "DownArrow",
		mods = "LEADER",
		action = act.ActivatePaneDirection("Down"),
	},
	{
		key = '"',
		mods = "LEADER",
		action = wezterm.action.SplitHorizontal({ domain = "CurrentPaneDomain" }),
	},
	{
		key = "%",
		mods = "LEADER",
		action = wezterm.action.SplitVertical({ domain = "CurrentPaneDomain" }),
	},
	{ key = "s", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|WORKSPACES" }) },
	{ key = "t", mods = "LEADER", action = wezterm.action.ShowLauncherArgs({ flags = "FUZZY|TABS" }) },
	{
		key = "w",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = wezterm.format({
				{ Attribute = { Intensity = "Bold" } },
				{ Foreground = { AnsiColor = "Fuchsia" } },
				{ Text = "Enter name for new workspace" },
			}),
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:perform_action(
						act.SwitchToWorkspace({
							name = line,
						}),
						pane
					)
				end
			end),
		}),
	},

	{
		key = "w",
		mods = "CMD",
		action = wezterm.action.CloseCurrentPane({ confirm = true }),
	},
	{
		key = "z",
		mods = "LEADER",
		action = wezterm.action.TogglePaneZoomState,
	},
	{
		key = "e",
		mods = "LEADER",
		action = act.PromptInputLine({
			description = "Enter new name for tab",
			action = wezterm.action_callback(function(window, pane, line)
				if line then
					window:active_tab():set_title(line)
				end
			end),
		}),
	},

	{ key = "S", mods = "LEADER", action = wezterm.action({ EmitEvent = "save_session" }) },
	{ key = "L", mods = "LEADER", action = wezterm.action({ EmitEvent = "load_session" }) },
	{ key = "r", mods = "LEADER", action = wezterm.action({ EmitEvent = "restore_session" }) },
}

return config
