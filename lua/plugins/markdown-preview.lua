return {
	"https://github.com/iamcco/markdown-preview.nvim",
	version = "^0.0.10",
	cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
	build = "cd app && yarn install",
	ft = { "markdown" },
}
