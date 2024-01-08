return {
    'nvim-telescope/telescope.nvim', tag = '0.1.5',
    -- or                              , branch = '0.1.x',
    dependencies = { 'nvim-lua/plenary.nvim' },
    keys = {
        -- find files
        { "<leader>pf", "<cmd>Telescope find_files<cr>", desc = "Find Files (root dir)" },
        -- git files
        { "<C-p>", "<cmd>Telescope git_files<cr>", desc = "Find Files (git dir)" },
        {'<leader>ps', function()
            local builtin = require('telescope.builtin')
            builtin.grep_string({ search = vim.fn.input("Grep > ") })
        end, desc = "Grep"},
        -- help files
        {"<leader>vh", "<cmd>Telescope help_tags<cr>", desc = "Help Files" }
    }
}


