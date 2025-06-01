return {
	"https://github.com/JoosepAlviste/nvim-ts-context-commentstring",

	keys = {
		{ "<leader>c", "gc", mode = "v", remap = true },
		{ "<leader>cc", "gcc", mode = "n", remap = true },
	},

	config = function()
		local commentstring = require("ts_context_commentstring")

		commentstring.setup({
			enable_autocmd = false,
		})

		-------------------------------------------------
		-- Setup for use with native neovim commenting --
		-------------------------------------------------

		local get_option = vim.filetype.get_option

		---@diagnostic disable-next-line: duplicate-set-field
		vim.filetype.get_option = function(filetype, option)
			return option == "commentstring" and require("ts_context_commentstring.internal").calculate_commentstring()
				or get_option(filetype, option)
		end
	end,
}
