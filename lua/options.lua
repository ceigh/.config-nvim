vim.cmd("colorscheme melange")

vim.o.termguicolors = true
vim.o.smartcase = true
vim.o.showmode = false
vim.o.undofile = true
vim.o.completeopt = "menu,menuone,noselect"
vim.o.cursorline = true
-- virt-column instead
vim.o.colorcolumn = ""
vim.o.expandtab = true
vim.o.tabstop = 2
vim.o.shiftwidth = 2
vim.o.listchars = "tab:⇥ ,trail:·"
vim.o.softtabstop = 2
vim.o.mouse = "a"

vim.bo.smartindent = true
vim.bo.swapfile = false

vim.wo.number = true
vim.wo.relativenumber = true
vim.wo.signcolumn = "yes"
vim.wo.wrap = false
