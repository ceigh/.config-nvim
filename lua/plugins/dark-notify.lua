return {
	enabled = false,
	"https://github.com/cormacrelf/dark-notify",
	event = "VeryLazy",
	config = function()
		require("dark_notify").run()
	end,
}
