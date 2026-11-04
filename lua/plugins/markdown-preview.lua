---@type LazySpec
return {
	"https://github.com/iamcco/markdown-preview.nvim",
	version = "^0.0.10",
	build = function()
		vim.fn["mkdp#util#install"]()
	end,
	ft = "markdown",
	keys = {
		{ "<leader>m", ":MarkdownPreviewToggle<CR>" },
	},

	init = function()
		vim.g.mkdp_page_title = "${name}.md"
		vim.g.mkdp_port = "3427"
	end,
}
