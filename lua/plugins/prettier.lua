local ft = {
	"html",
	"vue",
	"css",
	"scss",
	"typescript",
	"javascript",
	"json",
	"jsonc",
	"yaml",
	"graphql",
	"markdown",
}

return {
	enabled = false,

	"https://github.com/MunifTanjim/prettier.nvim",
	dependencies = {
		"https://github.com/jose-elias-alvarez/null-ls.nvim",
	},
	ft = ft,

	config = function()
		local fmt_on_save = require("utils").lsp.fmt_on_save

		require("null-ls").setup({
			on_attach = function(_, bufnr)
				fmt_on_save(bufnr)
			end,
		})

		require("prettier").setup({
			bin = "prettierd",
			filetypes = ft,
		})
	end,
}
