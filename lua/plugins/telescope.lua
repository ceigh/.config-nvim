return {
	"https://github.com/nvim-telescope/telescope.nvim",

	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-live-grep-args.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},

	keys = {
		{
			"<leader>rg",
			":lua require('telescope').extensions.live_grep_args.live_grep_args()<CR>",
			silent = true,
		},
	},

	config = function()
		local telescope = require("telescope")

		telescope.setup({
			defaults = {
				layout_strategy = "vertical",

				file_ignore_patterns = {
					"node_modules/.*",
					".git/.*",
					"yarn.lock",
					"bun.lock",
					"lazy-lock.json",
				},
			},

			extensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
				},
			},
		})

		telescope.load_extension("fzf")
		telescope.load_extension("live_grep_args")

		vim.api.nvim_set_hl(0, "TelescopeBorder", { link = "NeoTreeFloatBorder" })
		vim.api.nvim_set_hl(0, "TelescopeTitle", { link = "Number" })
	end,
}
