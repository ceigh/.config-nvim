local utils = require("utils")

---@type LazySpec
return {
	"https://github.com/lukas-reineke/indent-blankline.nvim",
	version = "^3.9.0",
	main = "ibl",
	event = "BufReadPre",
	enabled = false,

	---@module 'ibl'
	---@type ibl.config
	opts = {
		indent = {
			char = utils.VERTICAL_BAR_CHAR,
		},
		scope = {
			show_end = false,
			show_start = false,
		},
	},
}
