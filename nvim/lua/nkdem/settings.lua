vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.softtabstop = 4
vim.opt.expandtab = true -- tabs are spaces

vim.opt.smartindent = true  -- insert indents automatically

vim.opt.wrap = false -- don't wrap lines

vim.opt.swapfile = false -- don't create swap files
vim.opt.backup = false -- don't create backup files
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"  -- set undo directory
vim.opt.undofile = true -- create undo files


vim.opt.hlsearch = false -- don't highlight search results
vim.opt.incsearch = true -- search as characters are entered

vim.opt.termguicolors = true -- enable 24-bit RGB colors

vim.opt.scrolloff = 8 -- keep 8 lines above/below cursor when scrolling
