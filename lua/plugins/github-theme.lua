return {
	"https://github.com/projekt0n/github-nvim-theme",
	lazy = false,
	priority = 1000,
	config = function()
		vim.cmd("colorscheme github_dark_high_contrast")

		require("github-theme").setup({
			options = {
				styles = {
					comments = "italic",
				},
			},
		})
	end,
}
