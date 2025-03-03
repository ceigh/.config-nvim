return {
	enabled = false,

	"https://github.com/supermaven-inc/supermaven-nvim",
	event = "InsertEnter",

	config = {
		keymaps = {
			accept_suggestion = "<S-Up>",
		},
	},
}
