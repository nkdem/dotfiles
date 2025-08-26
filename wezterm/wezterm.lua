local wezterm = require("wezterm")

local act = wezterm.action
local config = wezterm.config_builder()

config.enable_scroll_bar = true

config.color_scheme = "Tokyo Night"

config.font_size = 20

config.send_composed_key_when_left_alt_is_pressed = true
config.send_composed_key_when_right_alt_is_pressed = false

return config
