---@type LazySpec
return {
	"https://git.sr.ht/~p00f/alabaster.nvim",
	lazy = false,
	priority = 1000,

	config = function()
		vim.g.alabaster_floatborder = true

		vim.cmd("colorscheme alabaster")

		vim.api.nvim_set_hl(0, "NonText", { link = "VertSplit" })
		vim.api.nvim_set_hl(0, "FloatBorder", { link = "NonText" })

		vim.api.nvim_set_hl(0, "BlinkCmpMenu", { link = "NormalFloat" })
		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
		vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "NormalFloat" })
		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
	end,
}
