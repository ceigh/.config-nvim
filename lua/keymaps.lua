vim.g.mapleader = ","

vim.keymap.set("n", ";", ":nohlsearch<CR>")
vim.keymap.set("n", "<leader>l", ":Lazy<CR>")
vim.keymap.set(
	"v",
	"<leader>t",
	":'<,'>!typograf --stdin --html-entity-type name --html-entity-only-invisible --no-color<CR>"
)
vim.keymap.set("n", "<leader>m", ":MarkdownPreviewToggle<CR>")
