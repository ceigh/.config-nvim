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

		-- check if in start tag
		local function is_in_start_tag()
			local ts_utils = require("nvim-treesitter.ts_utils")
			local node = ts_utils.get_node_at_cursor()
			if not node then
				return false
			end
			local node_to_check = {
				"start_tag",
				"self_closing_tag",
				"directive_attribute",
			}
			return vim.tbl_contains(node_to_check, node:type())
		end

		-- More Vue friendly completions
		-- https://github.com/vuejs/language-tools/discussions/4495
		local vue_entry_filter = function(entry, ctx)
			-- Use a buffer-local variable to cache the result
			-- of the Treesitter check
			local bufnr = ctx.bufnr
			local cached_is_in_start_tag = vim.b[bufnr]._vue_ts_cached_is_in_start_tag
			if cached_is_in_start_tag == nil then
				vim.b[bufnr]._vue_ts_cached_is_in_start_tag = is_in_start_tag()
			end
			-- If not in start tag, return true
			if vim.b[bufnr]._vue_ts_cached_is_in_start_tag == false then
				return true
			end

			-- Check if the buffer type is 'vue'
			if ctx.filetype ~= "vue" then
				return true
			end

			local cursor_before_line = ctx.cursor_before_line
			-- For events
			if cursor_before_line:sub(-1) == "@" then
				return entry.completion_item.label:match("^@") and not entry.completion_item.label:match("^@vnode")
				-- For props also exclude events with `:on-` prefix
			elseif cursor_before_line:sub(-1) == ":" then
				return entry.completion_item.label:match("^:") and not entry.completion_item.label:match("^:on%-")
			else
				return true
			end
		end

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
				{
					name = "nvim_lsp",
					entry_filter = vue_entry_filter,
				},
				{ name = "codeium", max_item_count = 8 },
				{ name = "snippy" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
		})

		-- Clean vue entry filter cache
		cmp.event:on("menu_closed", function()
			local bufnr = vim.api.nvim_get_current_buf()
			vim.b[bufnr]._vue_ts_cached_is_in_start_tag = nil
		end)

		-- Codeium
		require("codeium").setup({})
	end,
}
