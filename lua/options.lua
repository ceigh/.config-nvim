local colorcolumn = require("utils").colorcolumn

vim.o.colorcolumn = colorcolumn
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

vim.bo.smartindent = true
vim.bo.swapfile = false

vim.wo.number = true
vim.wo.relativenumber = false
vim.wo.signcolumn = "yes"
vim.wo.wrap = false
