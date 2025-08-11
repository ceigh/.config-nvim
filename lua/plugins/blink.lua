return {
	"https://github.com/saghen/blink.cmp",
	version = "^1.6.0",
	event = "InsertEnter",

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
	},
}
