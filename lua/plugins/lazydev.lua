---@type LazySpec
return {
	"https://github.com/folke/lazydev.nvim",
	-- Main branch until https://github.com/folke/lazydev.nvim/commit/ff2cbcba459b637ec3fd165a2be59b7bbaeedf0d released
	-- version = "^1.9.0",
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
