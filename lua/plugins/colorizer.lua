return {
	"https://github.com/norcalli/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	config = function()
		require("colorizer").setup({
			"*",
			css = { css = true },
			scss = { css = true },
		}, {
			names = false,
		})
	end,
}
