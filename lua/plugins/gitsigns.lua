return {
	"https://github.com/lewis6991/gitsigns.nvim",
	event = "VeryLazy",

	opts = {
		on_attach = function()
			local gitsigns = require("gitsigns")

			vim.keymap.set("n", "]g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "]g", bang = true })
				else
					gitsigns.nav_hunk("next")
				end
			end)

			vim.keymap.set("n", "[g", function()
				if vim.wo.diff then
					vim.cmd.normal({ "[g", bang = true })
				else
					gitsigns.nav_hunk("prev")
				end
			end)

			vim.keymap.set("n", "<leader>hr", gitsigns.reset_hunk)

			vim.keymap.set("v", "<leader>hr", function()
				gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
			end)

			vim.keymap.set("n", "<leader>hp", gitsigns.preview_hunk)
		end,
	},
}
