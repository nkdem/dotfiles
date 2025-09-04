return {
	"ravitemer/mcphub.nvim",
	dependencies = {
		"nvim-lua/plenary.nvim",
	},
	build = "bun install -g mcp-hub", -- Installs `mcp-hub` node binary globally
	config = function()
		require("mcphub").setup({
			extensions = {
				avante = {
					make_slash_commands = true,
				},
			},
		})
	end,
}
