-------------
-- Options --
-------------

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
vim.o.clipboard = "unnamedplus"
vim.o.laststatus = 0
vim.o.winborder = "none"
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.number = true
vim.o.signcolumn = "yes"

-- Disable unused providers
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0
vim.g.loaded_python3_provider = 0
vim.g.loaded_ruby_provider = 0

-------------
-- Keymaps --
-------------

vim.g.mapleader = ","

vim.keymap.set("n", ";", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>l", ":Lazy<CR>")
vim.keymap.set(
	"v",
	"<leader>t",
	":'<,'>!typograf --stdin --html-entity-type name --html-entity-only-invisible --no-color<CR>"
)

vim.keymap.set("n", "q", "<Nop>")

------------------
-- Plugins init --
------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install Lazy.nvim plugin manager
---@diagnostic disable-next-line: undefined-field
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable",
		lazypath,
	})
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup("plugins", {
	change_detection = { notify = false },
	ui = {
		icons = {
			cmd = "",
			config = "",
			event = "",
			ft = "",
			init = "",
			keys = "",
			plugin = "",
			runtime = "",
			require = "",
			source = "",
			start = "",
			task = "",
			lazy = "",
		},
	},
	rocks = { enabled = false },
})
