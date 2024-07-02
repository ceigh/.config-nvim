return {
	"https://github.com/nvim-neo-tree/neo-tree.nvim",
	branch = "v3.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
	},
	keys = {
		{ "\\", ":Neotree reveal float toggle<CR>", silent = true },
	},

	opts = {
		enable_diagnostics = false,
		popup_border_style = "rounded",

		default_component_configs = {
			container = {
				enable_character_fade = false,
			},
			icon = {
				folder_closed = "+",
				folder_open = "-",
				folder_empty = "-",
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
			window = {
				mappings = {
					-- Trash files instead of rm (lifesaver!)
					["d"] = function(state)
						local path = state.tree:get_node().path
						local msg = "Are you sure you want to trash " .. path .. "?"

						require("neo-tree.ui.inputs").confirm(msg, function(confirmed)
							if not confirmed then
								return
							end

							vim.fn.system("trash -F " .. vim.fn.fnameescape(path))
							require("neo-tree.sources.manager").refresh(state.name)
						end)
					end,
				},
			},
		},
	},
}
