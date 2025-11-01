---@type LazySpec
return {
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	version = "^3.33.0",
	dependencies = {
		"https://github.com/nvim-lua/plenary.nvim",
		"https://github.com/MunifTanjim/nui.nvim",
	},
	keys = {
		{ "\\", ":Neotree reveal float toggle<CR>", silent = true },
	},

	---@module 'neo-tree'
	---@type neotree.Config
	opts = {
		enable_diagnostics = false,
		popup_border_style = "",

		default_component_configs = {
			container = {
				enable_character_fade = false,
			},
			icon = {
				default = "*",
				folder_empty_open = "-",
				folder_closed = "+",
				folder_open = "-",
				folder_empty = "-",
				use_filtered_colors = false,
			},
			modified = { symbol = "" },
			git_status = {
				symbols = {
					added = "",
					modified = "",
					deleted = "",
					renamed = "",
					untracked = "",
					unstaged = "",
					staged = "",
					conflict = "",
					ignored = "",
				},
			},
		},

		filesystem = {
			filtered_items = {
				never_show = {
					".DS_Store",
					".git",
					"node_modules",
					"package-lock.json",
					"yarn.lock",
					"bun.lock",
					"bun.lockb",
					".nuxt",
					".output",
					"dist",
					"tsconfig.tsbuildinfo",
				},
				never_show_by_pattern = {
					".*.bun-build",
					".*.dump",
				},
			},

			window = {
				mappings = {
					-- Trash files instead of rm (lifesaver!)
					["d"] = function(state)
						---@diagnostic disable-next-line: undefined-field
						local path = state.tree:get_node().path
						local msg = "Are you sure you want to trash "
							.. path
							.. "?"

						require("neo-tree.ui.inputs").confirm(
							msg,
							function(confirmed)
								if not confirmed then
									return
								end

								vim.fn.system(
									"trash -F " .. vim.fn.fnameescape(path)
								)
								require("neo-tree.sources.manager").refresh(
									state.name
								)
							end
						)
					end,
				},
			},

			find_command = "fd",
		},
	},
}
