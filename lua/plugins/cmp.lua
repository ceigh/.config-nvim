return {
	"https://github.com/hrsh7th/nvim-cmp",
	dependencies = {
		{
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"dcampos/nvim-snippy",
			"dcampos/cmp-snippy",
		},
		{
			"Exafunction/codeium.nvim",
			dependencies = {
				"nvim-lua/plenary.nvim",
			},
		},
	},
	event = "InsertEnter",

	config = function()
		local cmp = require("cmp")
		local cmp_window_opts = { scrollbar = false }

		cmp.setup({
			window = {
				completion = cmp.config.window.bordered(cmp_window_opts),
				documentation = cmp.config.window.bordered(cmp_window_opts),
			},
			formatting = {
				expandable_indicator = false,
				format = function(_, vim_item)
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, 16)
					if truncated_label ~= label then
						vim_item.abbr = truncated_label .. "…"
					end
					vim_item.menu = nil
					return vim_item
				end,
			},

			snippet = {
				expand = function(args)
					require("snippy").expand_snippet(args.body)
				end,
			},

			mapping = cmp.mapping.preset.insert({
				["<C-z>"] = cmp.mapping.complete(),
				["<C-x>"] = cmp.mapping.abort(),
				["<Tab>"] = cmp.mapping.select_next_item(),
				["<S-Tab>"] = cmp.mapping.select_prev_item(),
				["<CR>"] = cmp.mapping.confirm({ select = true }),
			}),

			sources = cmp.config.sources({
				{ name = "nvim_lsp" },
				{ name = "codeium", max_item_count = 8 },
				{ name = "snippy" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		-- Codeium
		require("codeium").setup({})
	end,
}
