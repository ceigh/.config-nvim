---@type LazySpec
return {
	"https://github.com/iamcco/markdown-preview.nvim",
	version = "^0.0.10",
	build = "cd app && yarn install",
	ft = "markdown",
	keys = {
		{ "<leader>m", ":MarkdownPreviewToggle<CR>" },
	},
}
