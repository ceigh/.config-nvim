return {
	"https://github.com/hrsh7th/nvim-cmp",
	version = "^0.0.2",
	dependencies = {
		{
			"https://github.com/hrsh7th/cmp-nvim-lsp",
			"https://github.com/hrsh7th/cmp-buffer",
			"https://github.com/hrsh7th/cmp-path",
			{
				"https://github.com/dcampos/nvim-snippy",
				version = "^1.0.0",
			},
			"https://github.com/dcampos/cmp-snippy",
		},
	},
	event = "InsertEnter",

	config = function()
		local cmp = require("cmp")

		cmp.setup({
			formatting = {
				expandable_indicator = false,
				format = function(_, vim_item)
					local label = vim_item.abbr
					local truncated_label = vim.fn.strcharpart(label, 0, 20)
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
				{ name = "buffer" },
				{ name = "path" },
				{ name = "snippy" },
			}),
		})
	end,
}
