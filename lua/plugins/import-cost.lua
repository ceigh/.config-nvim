local ft = {
	"javascript",
	"typescript",
}

return {
	"https://github.com/barrett-ruth/import-cost.nvim",
	build = "sh install.sh bun install",
	ft = ft,

	config = {
		filetypes = ft,
		format = {
			virtual_text = "%s, gz: %s",
		},
	},
}
