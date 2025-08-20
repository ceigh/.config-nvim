---@type LazySpec
return {
	"https://github.com/projekt0n/github-nvim-theme",
	version = "^1.1.2",
	lazy = false,
	priority = 1000,

	config = function()
		require("github-theme").setup({
			options = {
				hide_nc_statusline = false,
				styles = {
					comments = "italic",
				},
			},
		})
	end,
}
