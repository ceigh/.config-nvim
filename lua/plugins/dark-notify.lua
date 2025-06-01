return {
	"https://github.com/cormacrelf/dark-notify",
	lazy = false,
	priority = 995,

	config = function()
		vim.cmd("colorscheme github_dark_high_contrast")

		require("dark_notify").run({
			schemes = {
				light = "github_light_high_contrast",
				dark = "github_dark_high_contrast",
			},
		})
	end,
}
