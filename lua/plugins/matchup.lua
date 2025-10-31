---@type LazySpec
return {
	"https://github.com/andymass/vim-matchup",
	version = "^0.8.0",

	---@module 'match-up'
	---@type matchup.Config
	opts = {
		matchparen = {
			offscreen = {},
		},
	},
}
