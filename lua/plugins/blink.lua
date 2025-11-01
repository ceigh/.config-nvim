local utils = require("utils")

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
				window = {
					max_width = utils.FLOAT_MAX_WIDTH,
					max_height = utils.FLOAT_MAX_HEIGHT,
				},
			},

			list = {
				selection = {
					preselect = false,
					auto_insert = true,
				},
			},

			menu = {
				min_width = utils.FLOAT_MAX_WIDTH,
				max_height = 8,

				draw = {
					columns = {
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},
					-- components = {
					-- 	label = {
					-- 		width = { max = 32 },
					-- 	},
					-- },
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
							-- Filter markdown output
							if item.documentation then
								if type(item.documentation) == "string" then
									item.documentation = utils.filter_markdown_content(item.documentation)
								elseif type(item.documentation) == "table" then
									if item.documentation.value then
										item.documentation.value =
											utils.filter_markdown_content(item.documentation.value)
									else
										item.documentation = utils.filter_markdown_content(item.documentation)
									end
								end
							end

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
