return {
	"zbirenbaum/copilot.lua",
	cmd = "Copilot",
	event = "InsertEnter",
	opts = {
		auto_trigger = true,
		filetypes = {
			markdown = true,
			yaml = true,
			lua = true,
		},
		suggestion = {
			enabled = true,
			auto_trigger = true,
			hide_during_completion = true,
			debounce = 75,
			keymap = {
				accept = "<Tab>",
				accept_word = "<M-n>",
				dismiss = "<C-]>",
			},
		},
	},
}
