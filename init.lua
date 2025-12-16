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
vim.o.cmdheight = 0
vim.o.laststatus = 2
vim.o.statusline = "%f"
vim.o.winborder = "rounded"
vim.o.smartindent = true
vim.o.swapfile = false
vim.o.number = true
vim.o.signcolumn = "number"
vim.o.textwidth = 0

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

------------------------------------------------------
-- Misspelled :quit command without Shift releasing --
------------------------------------------------------

local quit_commands = {
	Q = "q",
	Qa = "qa",
	QA = "qa",
	W = "w",
	Wq = "wq",
	WQ = "wq",
	Wqa = "wqa",
	WQa = "wqa",
	WQA = "wqa",
}

for alias, command in pairs(quit_commands) do
	vim.api.nvim_create_user_command(alias, command, { bang = true })
end

---------------
-- Custom ft --
---------------

vim.filetype.add({
	pattern = {
		[".*nginx.*%.conf%.template"] = "nginx",
	},
})

------------------
-- Plugins init --
------------------

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

-- Install Lazy.nvim plugin manager
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
