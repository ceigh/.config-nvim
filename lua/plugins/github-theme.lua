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

		-- vim.api.nvim_create_autocmd("ColorScheme", {
		-- 	pattern = "*",
		-- 	callback = function()
		-- 		vim.api.nvim_set_hl(0, "FloatBorder", { link = "Whitespace" })
		-- 		vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { link = "FloatBorder" })
		-- 		vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { link = "FloatBorder" })
		-- 		vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { link = "FloatBorder" })
		-- 	end,
		-- })
	end,
}
