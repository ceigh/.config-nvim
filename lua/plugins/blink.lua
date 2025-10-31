---@type LazySpec
return {
	"https://github.com/saghen/blink.cmp",
	version = "^1.6.0",
	event = "InsertEnter",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		keymap = {
			preset = "default",

			["<C-z>"] = { "show", "fallback" },
			["<C-x>"] = { "hide", "fallback" },
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },
			["<CR>"] = { "accept", "fallback" },
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 300,
			},

			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},

			menu = {
				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
				},
			},
		},

		sources = {
			default = {
				"lazydev",
				"lsp",
				"path",
				"snippets",
				"buffer",
			},

			providers = {
				lazydev = {
					name = "LazyDev",
					module = "lazydev.integrations.blink",
					score_offset = 100,
				},

				lsp = {
					transform_items = function(_, items)
						for _, item in ipairs(items) do
							-- Remove additionalTextEdits that are type imports
							if item.additionalTextEdits then
								item.additionalTextEdits = vim.tbl_filter(function(edit)
									return not (edit.newText and edit.newText:match("^%s*import%s+type%s+"))
								end, item.additionalTextEdits)
								if #item.additionalTextEdits == 0 then
									item.additionalTextEdits = nil
								end
							end

							-- Replace ~/ with @/ in import paths
							if item.textEdit and item.textEdit.newText then
								item.textEdit.newText = item.textEdit.newText:gsub("from%s+['\"]~/", "from '@/")
							end

							if item.additionalTextEdits then
								for _, edit in ipairs(item.additionalTextEdits) do
									if edit.newText then
										edit.newText = edit.newText:gsub("from%s+['\"]~/", "from '@/")
									end
								end
							end
						end
						return items
					end,
				},
			},
		},
	},
}
