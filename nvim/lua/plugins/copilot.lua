return {
    {
        "zbirenbaum/copilot.lua",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = function()
            require("copilot").setup({
                suggestion = {
                    auto_trigger = true,
                    		keymap = {
			accept = "<M-l>",
			accept_word = "<M-S-l>",
			accept_line = false,
			next = false,
			prev = false,
			dismiss = "<C-]>",
        }
                },
                panel = { enabled = false },
                filetypes = {
                    gitcommit = true,
                },
            })
        end,
    }
}
