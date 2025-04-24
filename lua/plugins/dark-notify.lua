return {
	"https://github.com/cormacrelf/dark-notify",
	event = "VeryLazy",
	lazy = false,
	priority = 900,
	config = function()
		require("dark_notify").run({
			schemes = {
				light = "github_light_high_contrast",
				dark = "github_dark_high_contrast",
			},
		})
	end,
}
