---@type LazySpec
return {
	"https://github.com/nvim-telescope/telescope.nvim",
	version = "^0.1.8",
	dependencies = {
		"https://github.com/nvim-lua/plenary.nvim",
	},
	keys = {
		{ "\\", ":Telescope find_files<CR>", silent = true },
		{ "]\\", ":Telescope live_grep<CR>", silent = true },
	},
	enabled = false,

	config = function()
		require("telescope").setup({})
	end,
}
