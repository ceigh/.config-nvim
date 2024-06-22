vim.o.colorcolumn = "80"
vim.o.termguicolors = true
vim.o.smartcase = true
vim.o.showmode = false
vim.o.undofile = true
vim.o.completeopt = "menu,menuone,noselect"
vim.o.cursorline = true
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.listchars = "tab:⇥ ,trail:·"
vim.o.softtabstop = 2
vim.o.mouse = "a"
vim.o.clipboard = "unnamedplus"

vim.bo.smartindent = true
vim.bo.swapfile = false

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = true

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0
