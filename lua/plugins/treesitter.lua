---@type LazySpec
return {
	"https://github.com/nvim-treesitter/nvim-treesitter",
	branch = "main",
	lazy = false,
	build = ":TSUpdate",

	config = function()
		vim.api.nvim_create_autocmd("User", {
			pattern = "TSUpdate",
			callback = function()
				local parsers = require("nvim-treesitter.parsers")

				parsers.caddyfile = {
					install_info = {
						url = "https://github.com/caddyserver/tree-sitter-caddyfile",
						revision = "6e62b4e297c955f050a6542a8d24df2f223a90e8",
						queries = "queries",
					},
					tier = 3,
				}
			end,
		})

		require("nvim-treesitter").install({
			"bash",
			"comment",
			"css",
			"git_config",
			"gitattributes",
			"gitignore",
			"go",
			"graphql",
			"html",
			"javascript",
			"jsdoc",
			"json",
			"json5",
			"lua",
			"make",
			"markdown",
			"markdown_inline",
			"scss",
			"typescript",
			"vim",
			"vue",
			"yaml",
			"gleam",
			"prisma",
			"dockerfile",
			"nginx",
		})

		vim.api.nvim_create_autocmd("FileType", {
			callback = function()
				pcall(vim.treesitter.start)
			end,
		})
	end,
}
