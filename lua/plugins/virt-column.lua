---@type LazySpec
return {
	"https://github.com/lukas-reineke/virt-column.nvim",
	version = "^2.0.3",
	event = "VeryLazy",

	---@module 'virt-column'
	---@type virtcolumn.config
	opts = {
		char = "⎸",
	},
}
