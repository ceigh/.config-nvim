---@type LazySpec
return {
	"https://github.com/folke/lazydev.nvim",
	version = "^1.9.0",
	ft = "lua",
	event = { "BufReadPre", "BufNewFile" },

	---@module 'lazydev'
	---@type lazydev.Config
	opts = {
		library = {
			{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
			"lazy.nvim",
		},
	},
}
