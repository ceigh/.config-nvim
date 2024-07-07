local map_key = require("utils").map_key

vim.g.mapleader = ","

map_key("<up>", "<nop>", "")
map_key("<down>", "<nop>", "")
map_key("<left>", "<nop>", "")
map_key("<right>", "<nop>", "")
map_key("q", "<nop>", "")

map_key("gc", "<nop>", "")
map_key("gcc", "<nop>", "")

map_key(";", ":nohlsearch<CR>")
map_key("<leader>l", ":Lazy<CR>")

map_key("<leader>t", ":'<,'>!typograf --stdin --html-entity-type name --html-entity-only-invisible --no-color<CR>", "v")

map_key("<leader>s", function()
	vim.o.spell = not vim.o.spell
	if vim.o.spell then
		vim.o.spelllang = "en_us"
	end
end)

map_key("<leader>m", ":MarkdownPreviewToggle<CR>")
